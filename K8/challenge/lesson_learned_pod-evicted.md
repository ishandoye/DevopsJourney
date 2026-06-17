# Kubernetes OOMKilled Incident - Lessons Learned & Production Best Practices

## Incident Summary

### Symptoms Observed

```bash
[root@rhel9-4gb ~]# kubectl get pods -n pod-evicted

NAME                             READY   STATUS             RESTARTS
data-processor-d66fc797f-cn8sc   0/1     CrashLoopBackOff   8
```

Initial symptom was `CrashLoopBackOff`.

---

## Investigation Performed

### Check Pod Details

```bash
kubectl describe pod data-processor-d66fc797f-cn8sc -n pod-evicted
```

### Check Full YAML

```bash
kubectl get pod data-processor-d66fc797f-cn8sc \
-o yaml -n pod-evicted
```

Observed:

```yaml
lastState:
  terminated:
    exitCode: 137
    reason: OOMKilled
```

### Root Cause Identified

Container memory limit:

```yaml
resources:
  limits:
    memory: 50Mi
```

Application behavior:

```python
for i in range(10):
    chunk = 'x' * (8 * 1024 * 1024)
```

Approximate allocation:

```text
10 × 8 MB ≈ 80 MB+
```

Configured limit:

```text
50Mi
```

Result:

```text
Application Memory Usage > Container Memory Limit
```

Linux OOM Killer terminated the process.

---

# Important Lessons Learned

## Lesson 1 - CrashLoopBackOff Is Not The Root Cause

CrashLoopBackOff is only a symptom.

Always determine why the container exited.

Useful commands:

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name> --previous
kubectl get pod <pod-name> -o yaml
```

Always look for:

- Exit Code
- Last State
- Events
- Container Reason

Examples:

- OOMKilled
- ImagePullBackOff
- CreateContainerConfigError
- FailedMount
- Probe Failure
- Application Crash

---

## Lesson 2 - Fix The Controller, Not The Pod

Kubernetes hierarchy:

```text
Deployment
    ↓
ReplicaSet
    ↓
Pod
```

Avoid:

```bash
kubectl edit pod <pod-name>
```

Reason:

Pods are ephemeral.

Any replacement pod will inherit configuration from the Deployment.

Correct location for changes:

```text
Deployment
StatefulSet
DaemonSet
```

depending on workload type.

---

## Lesson 3 - Understand Exit Code 137

Exit Code:

```text
137
```

Usually indicates:

```text
SIGKILL
```

In Kubernetes the most common cause is:

```text
OOMKilled
```

Verification:

```bash
kubectl describe pod <pod-name>
```

or

```bash
kubectl get pod <pod-name> -o yaml
```

Look for:

```yaml
reason: OOMKilled
exitCode: 137
```

---

## Lesson 4 - Never Increase Resources Blindly

Before increasing memory:

Verify:

- Application behavior
- Memory consumption pattern
- Memory leak possibility
- Historical usage
- Resource requests and limits

Questions to answer:

- Is this expected workload growth?
- Is there a memory leak?
- Is the limit incorrectly configured?
- Is the application sizing known?

---

## Lesson 5 - Avoid Stale YAML During Active Incidents

Observed error:

```bash
kubectl apply -f data-processor-5b64d56fc4-bkpm7.yaml
```

Result:

```text
Operation cannot be fulfilled on deployments.apps
the object has been modified
```

Reason:

```text
Deployment exported
        ↓
Deployment changed
        ↓
Old YAML applied
        ↓
ResourceVersion conflict
```

Lesson:

Exported manifests can become stale quickly.

---

## Lesson 6 - Preferred Production Change Method

For emergency resource updates:

```bash
kubectl set resources deployment data-processor \
-n pod-evicted \
--limits=cpu=200m,memory=256Mi \
--requests=cpu=100m,memory=128Mi
```

Benefits:

- Fast
- Direct Deployment update
- No YAML conflicts
- Automatic rollout
- Suitable for incidents

---

## Lesson 7 - Validate Every Change

After any production change:

### Verify rollout

```bash
kubectl rollout status deployment/data-processor \
-n pod-evicted
```

### Monitor pods

```bash
kubectl get pods -n pod-evicted -w
```

### Check logs

```bash
kubectl logs <pod-name> -n pod-evicted
```

### Check events

```bash
kubectl describe pod <pod-name>
```

Never assume success based only on a successful command execution.

---

# Recommended Production Workflow - OOMKilled / CrashLoopBackOff

## Scenario

Alert received:

```bash
kubectl get pods -n pod-evicted
```

Output:

```text
NAME                             READY   STATUS             RESTARTS
data-processor-d66fc797f-cn8sc   0/1     CrashLoopBackOff   8
```

---

# Step 1 - Verify Current Pod State

Command:

```bash
kubectl get pods -n pod-evicted -o wide
```

Purpose:

* Confirm affected pod
* Confirm node placement
* Confirm restart count

Expected Output:

```text
STATUS = CrashLoopBackOff
RESTARTS > 0
```

If restart count continuously increases:

Proceed to Step 2.

---

# Step 2 - Check Kubernetes Events

Command:

```bash
kubectl describe pod data-processor-d66fc797f-cn8sc -n pod-evicted
```

Purpose:

Review:

* Events
* Exit reason
* Scheduling issues
* Probe failures
* Mount failures

Look for:

```text
OOMKilled
```

or

```text
Back-off restarting failed container
```

If OOMKilled found:

Proceed to Step 3.

---

# Step 3 - Inspect Previous Container Logs

Command:

```bash
kubectl logs data-processor-d66fc797f-cn8sc \
-n pod-evicted \
--previous
```

Purpose:

View logs from crashed container.

Questions:

* Did application throw exception?
* Did process terminate itself?
* Did logs stop abruptly?

For OOM events logs often stop suddenly.

---

# Step 4 - Retrieve Complete Pod Configuration

Command:

```bash
kubectl get pod data-processor-d66fc797f-cn8sc \
-n pod-evicted \
-o yaml
```

Purpose:

Verify:

```yaml
resources:
  requests:
  limits:
```

Check:

```yaml
resources:
  limits:
    memory: 50Mi
```

Record configured limit.

---

# Step 5 - Identify Owning Controller

Command:

```bash
kubectl get pod data-processor-d66fc797f-cn8sc -o yaml -n pod-evicted | grep -A10 ownerReferences
```

Expected:

```yaml
ownerReferences:
- kind: ReplicaSet
  name: data-processor-d66fc797f
```

Then:

```bash
kubectl get rs -n pod-evicted
```

Find owning ReplicaSet.

Then:

```bash
kubectl describe rs data-processor-d66fc797f -n pod-evicted
```

Identify Deployment.

Expected:

```text
Controlled By:
Deployment/data-processor
```

---

# Step 6 - Verify Deployment Resources

Command:

```bash
kubectl get deployment data-processor -n pod-evicted -o yaml
```

Review:

```yaml
spec:
  template:
    spec:
      containers:
      - resources:
```

Confirm:

```yaml
limits:
  memory: 50Mi
```

---

# Step 7 - Emergency Production Fix

Preferred:

```bash
kubectl set resources deployment data-processor \
-n pod-evicted \
--limits=cpu=200m,memory=256Mi \
--requests=cpu=100m,memory=128Mi
```

Purpose:

Update Deployment template.

Kubernetes automatically:

```text
Creates new ReplicaSet
Creates new Pod
Terminates old Pod
```

---

# Step 8 - Verify Rollout

Command:

```bash
kubectl rollout status deployment/data-processor -n pod-evicted
```

Expected:

```text
deployment "data-processor" successfully rolled out
```

If rollout hangs:

Investigate new pod.

---

# Step 9 - Monitor New Pods

Command:

```bash
kubectl get pods -n pod-evicted -w
```

Expected:

```text
Running
1/1 Ready
```

Not:

```text
CrashLoopBackOff
```

---

# Step 10 - Verify New Resource Values

Command:

```bash
kubectl describe pod <new-pod-name> -n pod-evicted
```

Verify:

```text
Limits:
  memory: 256Mi
```

Confirm change propagated.

---

# Step 11 - Verify Application Logs

Command:

```bash
kubectl logs <new-pod-name> -n pod-evicted
```

Verify:

```text
Application starts successfully
No OOM events
No exceptions
```

---

# Step 12 - Verify Deployment Health

Command:

```bash
kubectl get deployment data-processor -n pod-evicted
```

Expected:

```text
READY 1/1
AVAILABLE 1
```

---

# Step 13 - Verify Cluster Events

Command:

```bash
kubectl get events -n pod-evicted --sort-by=.lastTimestamp
```

Verify:

* No new OOMKilled events
* No scheduling failures
* No probe failures

---

# Step 14 - Document Production Change

Record:

* Incident Time
* Root Cause
* Memory Before: 50Mi
* Memory After: 256Mi
* Validation Commands
* Recovery Time

---

# Step 15 - Update Source Of Truth

Update:

```text
Git Repository
Terraform

```

Reason:

Future deployments must retain the fix.

---

# Optional Capacity Verification

Check actual usage:

```bash
kubectl top pod -n pod-evicted
```

or

```bash
kubectl top pod <pod-name> -n pod-evicted
```

Purpose:

Determine:

```text
Actual Usage
Configured Request
Configured Limit
```

Use this data for future sizing.

---

# Rollback Procedure

If application becomes unstable after change:

View revisions:

```bash
kubectl rollout history deployment/data-processor -n pod-evicted
```

Rollback:

```bash
kubectl rollout undo deployment/data-processor -n pod-evicted
```

Verify:

```bash
kubectl rollout status deployment/data-processor -n pod-evicted
```

---

# Final Decision Flow
```
CrashLoopBackOff
↓
Describe Pod
↓
Identify Exit Reason
↓
OOMKilled?
↓
YES
↓
Verify Limits
↓
Modify Deployment
↓
Validate Rollout
↓
Verify Logs
↓
Update Git
↓
Close Incident
```

