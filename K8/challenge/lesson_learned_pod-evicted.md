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

# Recommended Production Workflow

## Step 1 - Confirm Impact

```bash
kubectl get pods -n pod-evicted
```

## Step 2 - Investigate

```bash
kubectl describe pod <pod-name>
```

## Step 3 - Review Logs

```bash
kubectl logs <pod-name> --previous
```

## Step 4 - Determine Root Cause

Examples:

- OOMKilled
- Probe Failure
- FailedMount
- ImagePullBackOff
- Application Crash

## Step 5 - Identify Owning Controller

```bash
kubectl get pod <pod-name> -o yaml
```

Review:

```yaml
ownerReferences:
```

## Step 6 - Fix Controller

Modify:

- Deployment
- StatefulSet
- DaemonSet

Do not modify Pods.

## Step 7 - Validate Rollout

```bash
kubectl rollout status deployment/<deployment>
```

## Step 8 - Verify Recovery

```bash
kubectl get pods
kubectl logs
kubectl describe
```

## Step 9 - Update Source Of Truth

After emergency production changes update:

- Git Repository
- Helm Charts
- Kustomize
- Terraform
- GitOps Repository

This prevents future deployments from reverting the fix.

---

# What To Avoid In Production

❌ Editing Pods directly

❌ Repeatedly deleting Pods without investigation

❌ Increasing limits without understanding usage

❌ Applying stale exported YAML

❌ Skipping rollout validation

❌ Forgetting to update Git/source control

❌ Treating CrashLoopBackOff as root cause

---

# Production Best Practices

✅ Investigate before changing

✅ Confirm actual exit reason

✅ Fix Deployment instead of Pod

✅ Use controlled rollouts

✅ Validate post-change behavior

✅ Update source-controlled configuration

✅ Document lessons learned

✅ Review resource sizing after incident closure

---

# Final Takeaway

```text
CrashLoopBackOff = Symptom

OOMKilled = Root Cause

Deployment = Correct place to fix

Production Workflow:
Investigate → Identify Root Cause → Fix Controller → Validate Rollout → Update Source Of Truth
```

