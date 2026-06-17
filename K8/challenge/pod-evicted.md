- Start the Challange
```bash

[root@rhel9-4gb ~]# kubeasy challenge get pod-evicted



# Pod Evicted

Difficulty: easy
Theme: Resources & Scaling
Slug: pod-evicted

┌──────────────────────────── Description ────────────────────────────┐
| A data processing pod keeps crashing and getting evicted.           |
| It was working fine yesterday, but now Kubernetes keeps killing it. |
|                                                                     |
└─────────────────────────────────────────────────────────────────────┘


# Initial Situation

A data processing application is deployed as a single pod.
The pod starts but keeps crashing after a few seconds.
It enters a CrashLoopBackOff state and keeps restarting.
The application code hasn't changed - it was working fine in the previous environment.


 INFO  Press Enter to continue...

[root@rhel9-4gb ~]#

```

- Start your first challenge

```bash

[root@rhel9-4gb ~]# kubeasy challenge start pod-evicted


# Starting Challenge: pod-evicted

 SUCCESS  Fetching challenge details
 INFO  Challenge: Pod Evicted
 SUCCESS  Checking challenge progress

 SUCCESS  Creating namespace
 SUCCESS  Deploying challenge
 SUCCESS  Kubectl context configured
 SUCCESS  Registering challenge progress

 SUCCESS  Challenge environment is ready!
Challenge: pod-evicted
Namespace: pod-evicted
Context: kind-kubeasy

 INFO  You can now start working on the challenge!


```

- Start Troubelshooting 

```bash

[root@rhel9-4gb ~]# kubectl get pods
NAME                             READY   STATUS      RESTARTS      AGE
data-processor-d66fc797f-sjctm   0/1     OOMKilled   3 (44s ago)   77s
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl describe pods
Name:             data-processor-d66fc797f-sjctm
Namespace:        pod-evicted
Priority:         0
Service Account:  default
Node:             kubeasy-control-plane/172.18.0.2
Start Time:       Tue, 16 Jun 2026 08:22:44 +0000
Labels:           app=data-processor
                  pod-template-hash=d66fc797f
Annotations:      <none>
Status:           Running
IP:               10.244.0.23
IPs:
  IP:           10.244.0.23
Controlled By:  ReplicaSet/data-processor-d66fc797f
Containers:
  processor:
    Container ID:  containerd://22fc5da5890697408edbea3219df7457135c1240e467813d3f5dca6517d90ed2
    Image:         python:3.11-slim
    Image ID:      docker.io/library/python@sha256:f9fa7f851e38bfb19c9de3afbc4b86ae7176ea7aaf94535c31df5458d5849457
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/sh
    Args:
      -c
      echo "=========================================="
      echo "Data Processor Starting..."
      echo "=========================================="
      echo "Allocating memory for data processing..."

      python3 -c "
      import time
      import sys

      print('Loading data into memory...')
      data = []
      for i in range(10):
          chunk = 'x' * (8 * 1024 * 1024)
          data.append(chunk)
          print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')
          time.sleep(1)

      print('Data loaded successfully!')
      print('Processing data...')

      while True:
          print('Processing batch...')
          time.sleep(10)
      "

    State:          Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Tue, 16 Jun 2026 08:23:42 +0000
      Finished:     Tue, 16 Jun 2026 08:23:48 +0000
    Last State:     Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Tue, 16 Jun 2026 08:23:11 +0000
      Finished:     Tue, 16 Jun 2026 08:23:17 +0000
    Ready:          False
    Restart Count:  3
    Limits:
      cpu:     200m
      memory:  50Mi
    Requests:
      cpu:     100m
      memory:  32Mi
    Environment:
      PYTHONUNBUFFERED:  1
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-g8m7s (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       False
  ContainersReady             False
  PodScheduled                True
Volumes:
  kube-api-access-g8m7s:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  85s                default-scheduler  Successfully assigned pod-evicted/data-processor-d66fc797f-sjctm to kubeasy-control-plane
  Normal   Pulled     27s (x4 over 84s)  kubelet            Container image "python:3.11-slim" already present on machine and can be accessed by the pod
  Normal   Created    27s (x4 over 84s)  kubelet            Container created
  Normal   Started    27s (x4 over 84s)  kubelet            Container started
  Warning  BackOff    21s (x3 over 71s)  kubelet            Back-off restarting failed container processor in pod data-processor-d66fc797f-sjctm_pod-evicted(02b9515f-3566-49da-aab6-4082e4b16cf5)
[root@rhel9-4gb ~]#

```

-   The Error looks to be related to OOM. 
	- Review Describe

- Some Important Key points from Description.

```bash

    Args:
      -c
      echo "=========================================="
      echo "Data Processor Starting..."
      echo "=========================================="
      echo "Allocating memory for data processing..."

      python3 -c "
      import time
      import sys

      print('Loading data into memory...')
      data = []
      for i in range(10):
          chunk = 'x' * (8 * 1024 * 1024)
          data.append(chunk)
          print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')
          time.sleep(1)

      print('Data loaded successfully!')
      print('Processing data...')

      while True:
          print('Processing batch...')
          time.sleep(10)
      "

    State:          Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Tue, 16 Jun 2026 08:23:42 +0000
      Finished:     Tue, 16 Jun 2026 08:23:48 +0000
    Last State:     Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Tue, 16 Jun 2026 08:23:11 +0000
      Finished:     Tue, 16 Jun 2026 08:23:17 +0000

```
	
- Checked Logs

```bash

[root@rhel9-4gb ~]# kubectl get pod
NAME                             READY   STATUS      RESTARTS        AGE
data-processor-d66fc797f-sjctm   0/1     OOMKilled   5 (2m19s ago)   4m12s
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl logs data-processor-d66fc797f-sjctm
==========================================
Data Processor Starting...
==========================================
Allocating memory for data processing...
Loading data into memory...
Loaded chunk 1/10 (~8MB in memory)
Loaded chunk 2/10 (~16MB in memory)
Loaded chunk 3/10 (~24MB in memory)
Loaded chunk 4/10 (~32MB in memory)
Loaded chunk 5/10 (~40MB in memory)
[root@rhel9-4gb ~]#

```

- The Chunks area going till 5 but not till 10 as per python code.

```bash

     for i in range(10):
          chunk = 'x' * (8 * 1024 * 1024)
          data.append(chunk)
          print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')


```

- Now need to check for the Yaml.

``bash

[root@rhel9-4gb ~]# kubectl get pod
NAME                             READY   STATUS             RESTARTS        AGE
data-processor-d66fc797f-sjctm   0/1     CrashLoopBackOff   230 (96s ago)   19h


[root@rhel9-4gb ~]# kubectl get pod -o yaml > data-processor.yaml
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# cp -av data-processor.yaml data-processor.yaml_org
'data-processor.yaml' -> 'data-processor.yaml_org'
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# vi data-processor.yaml
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl get pods
NAME                             READY   STATUS             RESTARTS         AGE
data-processor-d66fc797f-sjctm   0/1     CrashLoopBackOff   230 (4m2s ago)   19h
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl logs data-processor-d66fc797f-sjctm|tail
==========================================
Data Processor Starting...
==========================================
Allocating memory for data processing...
Loading data into memory...
Loaded chunk 1/10 (~8MB in memory)
Loaded chunk 2/10 (~16MB in memory)
Loaded chunk 3/10 (~24MB in memory)
Loaded chunk 4/10 (~32MB in memory)
Loaded chunk 5/10 (~40MB in memory)

```

- Now lets looks at the pod yaml file
	- At first I was using below command to get the pods yaml

```bash
[root@rhel9-4gb ~]# kubectl get pods data-processor-d66fc797f-cn8sc -o yaml > data-processor-d66fc797f-cn8sc.yaml
```

	- This was confusing to me as it was showing me more value of memory.

```bash

[root@rhel9-4gb ~]# grep memory data-processor-d66fc797f-cn8sc.yaml
      echo "Allocating memory for data processing..."
      print('Loading data into memory...')
          print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')
        memory: 50Mi
        memory: 32Mi
      memory: 32Mi
        memory: 50Mi
        memory: 32Mi

```

	- So Instead of POD, I tried using deployment

```bash

[root@rhel9-4gb ~]# kubectl get deployment data-processor -n pod-evicted -o yaml > data-processor.yaml
[root@rhel9-4gb ~]# cat data-processor.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  creationTimestamp: "2026-06-16T08:22:44Z"
  generation: 1
  name: data-processor
  namespace: pod-evicted
  resourceVersion: "1249459"
  uid: e766c00d-632a-4529-bf9a-d6dde837f142
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: data-processor
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: data-processor
    spec:
      containers:
      - args:
        - -c
        - |
          echo "=========================================="
          echo "Data Processor Starting..."
          echo "=========================================="
          echo "Allocating memory for data processing..."

          python3 -c "
          import time
          import sys

          print('Loading data into memory...')
          data = []
          for i in range(10):
              chunk = 'x' * (8 * 1024 * 1024)
              data.append(chunk)
              print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')
              time.sleep(1)

          print('Data loaded successfully!')
          print('Processing data...')

          while True:
              print('Processing batch...')
              time.sleep(10)
          "
        command:
        - /bin/sh
        env:
        - name: PYTHONUNBUFFERED
          value: "1"
        image: python:3.11-slim
        imagePullPolicy: IfNotPresent
        name: processor
        resources:
          limits:
            cpu: 200m
            memory: 50Mi
          requests:
            cpu: 100m
            memory: 32Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  conditions:
  - lastTransitionTime: "2026-06-16T08:22:44Z"
    lastUpdateTime: "2026-06-16T08:22:45Z"
    message: ReplicaSet "data-processor-d66fc797f" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  - lastTransitionTime: "2026-06-17T04:25:23Z"
    lastUpdateTime: "2026-06-17T04:25:23Z"
    message: Deployment does not have minimum availability.
    reason: MinimumReplicasUnavailable
    status: "False"
    type: Available
  observedGeneration: 1
  replicas: 1
  terminatingReplicas: 0
  unavailableReplicas: 1
  updatedReplicas: 1

```

	- Now this looks sorted.

```bash

[root@rhel9-4gb ~]# grep memory data-processor.yaml
          echo "Allocating memory for data processing..."
          print('Loading data into memory...')
              print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')
            memory: 50Mi
            memory: 32Mi
[root@rhel9-4gb ~]#

```

- Lets sorted it.
	- The python code start with 8Mb till 80Mb as it ranges to 10.
	- But looking at the memory limit is set to 50 and requests is on 32 mb.
	- so we can change 50mb to 80mb and lets see if our issue gets resolved or not.

	
```bash

[root@rhel9-4gb ~]# kubectl get pods
NAME                             READY   STATUS      RESTARTS         AGE
data-processor-d66fc797f-cn8sc   0/1     OOMKilled   11 (5m36s ago)   32m
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# cp -av data-processor.yaml data-processor-d66fc797f-cn8sc.yaml
cp: overwrite 'data-processor-d66fc797f-cn8sc.yaml'? y
'data-processor.yaml' -> 'data-processor-d66fc797f-cn8sc.yaml'
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl logs data-processor-d66fc797f-cn8sc|tail
==========================================
Data Processor Starting...
==========================================
Allocating memory for data processing...
Loading data into memory...
Loaded chunk 1/10 (~8MB in memory)
Loaded chunk 2/10 (~16MB in memory)
Loaded chunk 3/10 (~24MB in memory)
Loaded chunk 4/10 (~32MB in memory)
Loaded chunk 5/10 (~40MB in memory)
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#

[root@rhel9-4gb ~]# vi data-processor-d66fc797f-cn8sc.yaml
[root@rhel9-4gb ~]# diff data-processor-d66fc797f-cn8sc.yaml data-processor.yaml
68c68
<             memory: 80Mi
---
>             memory: 50Mi
[root@rhel9-4gb ~]#

[root@rhel9-4gb ~]# kubectl apply -f data-processor-d66fc797f-cn8sc.yaml --force
Warning: resource deployments/data-processor is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
deployment.apps/data-processor configured
[root@rhel9-4gb ~]#


[root@rhel9-4gb ~]# kubectl logs data-processor-5b64d56fc4-bkpm7|tail
Loading data into memory...
Loaded chunk 1/10 (~8MB in memory)
Loaded chunk 2/10 (~16MB in memory)
Loaded chunk 3/10 (~24MB in memory)
Loaded chunk 4/10 (~32MB in memory)
Loaded chunk 5/10 (~40MB in memory)
Loaded chunk 6/10 (~48MB in memory)
Loaded chunk 7/10 (~56MB in memory)
Loaded chunk 8/10 (~64MB in memory)
Loaded chunk 9/10 (~72MB in memory)

```

- It is faild lets change it to 90mb.

```bash
[root@rhel9-4gb ~]# diff data-processor-d66fc797f-cn8sc.yaml data-processor.yaml
68c68
<             memory: 90Mi
---
>             memory: 50Mi
[root@rhel9-4gb ~]#

```
- I was testing if the only apply will help us but got errors. 
	- here is what I tried.

```bash
[root@rhel9-4gb ~]# kubectl apply -f data-processor-d66fc797f-cn8sc.yaml
Error from server (Conflict): error when applying patch:
{"metadata":{"annotations":{"kubectl.kubernetes.io/last-applied-configuration":"{\"apiVersion\":\"apps/v1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{\"deployment.kubernetes.io/revision\":\"1\"},\"creationTimestamp\":\"2026-06-16T08:22:44Z\",\"generation\":1,\"name\":\"data-processor\",\"namespace\":\"pod-evicted\",\"resourceVersion\":\"1249459\",\"uid\":\"e766c00d-632a-4529-bf9a-d6dde837f142\"},\"spec\":{\"progressDeadlineSeconds\":600,\"replicas\":1,\"revisionHistoryLimit\":10,\"selector\":{\"matchLabels\":{\"app\":\"data-processor\"}},\"strategy\":{\"rollingUpdate\":{\"maxSurge\":\"25%\",\"maxUnavailable\":\"25%\"},\"type\":\"RollingUpdate\"},\"template\":{\"metadata\":{\"labels\":{\"app\":\"data-processor\"}},\"spec\":{\"containers\":[{\"args\":[\"-c\",\"echo \\\"==========================================\\\"\\necho \\\"Data Processor Starting...\\\"\\necho \\\"==========================================\\\"\\necho \\\"Allocating memory for data processing...\\\"\\n\\npython3 -c \\\"\\nimport time\\nimport sys\\n\\nprint('Loading data into memory...')\\ndata = []\\nfor i in range(10):\\n    chunk = 'x' * (8 * 1024 * 1024)\\n    data.append(chunk)\\n    print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')\\n    time.sleep(1)\\n\\nprint('Data loaded successfully!')\\nprint('Processing data...')\\n\\nwhile True:\\n    print('Processing batch...')\\n    time.sleep(10)\\n\\\"\\n\"],\"command\":[\"/bin/sh\"],\"env\":[{\"name\":\"PYTHONUNBUFFERED\",\"value\":\"1\"}],\"image\":\"python:3.11-slim\",\"imagePullPolicy\":\"IfNotPresent\",\"name\":\"processor\",\"resources\":{\"limits\":{\"cpu\":\"200m\",\"memory\":\"90Mi\"},\"requests\":{\"cpu\":\"100m\",\"memory\":\"32Mi\"}},\"terminationMessagePath\":\"/dev/termination-log\",\"terminationMessagePolicy\":\"File\"}],\"dnsPolicy\":\"ClusterFirst\",\"restartPolicy\":\"Always\",\"schedulerName\":\"default-scheduler\",\"securityContext\":{},\"terminationGracePeriodSeconds\":30}}},\"status\":{\"conditions\":[{\"lastTransitionTime\":\"2026-06-16T08:22:44Z\",\"lastUpdateTime\":\"2026-06-16T08:22:45Z\",\"message\":\"ReplicaSet \\\"data-processor-d66fc797f\\\" has successfully progressed.\",\"reason\":\"NewReplicaSetAvailable\",\"status\":\"True\",\"type\":\"Progressing\"},{\"lastTransitionTime\":\"2026-06-17T04:25:23Z\",\"lastUpdateTime\":\"2026-06-17T04:25:23Z\",\"message\":\"Deployment does not have minimum availability.\",\"reason\":\"MinimumReplicasUnavailable\",\"status\":\"False\",\"type\":\"Available\"}],\"observedGeneration\":1,\"replicas\":1,\"terminatingReplicas\":0,\"unavailableReplicas\":1,\"updatedReplicas\":1}}\n"},"creationTimestamp":"2026-06-16T08:22:44Z","resourceVersion":"1249459","uid":"e766c00d-632a-4529-bf9a-d6dde837f142"},"spec":{"template":{"spec":{"$setElementOrder/containers":[{"name":"processor"}],"containers":[{"name":"processor","resources":{"limits":{"memory":"90Mi"}}}]}}},"status":{"$setElementOrder/conditions":[{"type":"Progressing"},{"type":"Available"}],"conditions":[{"lastTransitionTime":"2026-06-16T08:22:44Z","lastUpdateTime":"2026-06-16T08:22:45Z","message":"ReplicaSet \"data-processor-d66fc797f\" has successfully progressed.","type":"Progressing"},{"lastTransitionTime":"2026-06-17T04:25:23Z","lastUpdateTime":"2026-06-17T04:25:23Z","type":"Available"}]}}
to:
Resource: "apps/v1, Resource=deployments", GroupVersionKind: "apps/v1, Kind=Deployment"
Name: "data-processor", Namespace: "pod-evicted"
for: "data-processor-d66fc797f-cn8sc.yaml": error when patching "data-processor-d66fc797f-cn8sc.yaml": Operation cannot be fulfilled on deployments.apps "data-processor": the object has been modified; please apply your changes to the latest version and try again


[root@rhel9-4gb ~]# kubectl get pods
NAME                              READY   STATUS             RESTARTS        AGE
data-processor-5b64d56fc4-bkpm7   0/1     CrashLoopBackOff   6 (4m31s ago)   11m

[root@rhel9-4gb ~]# mv data-processor-d66fc797f-cn8sc.yaml data-processor-5b64d56fc4-bkpm7.yaml
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl apply -f data-processor-5b64d56fc4-bkpm7.yaml
Error from server (Conflict): error when applying patch:
{"metadata":{"annotations":{"kubectl.kubernetes.io/last-applied-configuration":"{\"apiVersion\":\"apps/v1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{\"deployment.kubernetes.io/revision\":\"1\"},\"creationTimestamp\":\"2026-06-16T08:22:44Z\",\"generation\":1,\"name\":\"data-processor\",\"namespace\":\"pod-evicted\",\"resourceVersion\":\"1249459\",\"uid\":\"e766c00d-632a-4529-bf9a-d6dde837f142\"},\"spec\":{\"progressDeadlineSeconds\":600,\"replicas\":1,\"revisionHistoryLimit\":10,\"selector\":{\"matchLabels\":{\"app\":\"data-processor\"}},\"strategy\":{\"rollingUpdate\":{\"maxSurge\":\"25%\",\"maxUnavailable\":\"25%\"},\"type\":\"RollingUpdate\"},\"template\":{\"metadata\":{\"labels\":{\"app\":\"data-processor\"}},\"spec\":{\"containers\":[{\"args\":[\"-c\",\"echo \\\"==========================================\\\"\\necho \\\"Data Processor Starting...\\\"\\necho \\\"==========================================\\\"\\necho \\\"Allocating memory for data processing...\\\"\\n\\npython3 -c \\\"\\nimport time\\nimport sys\\n\\nprint('Loading data into memory...')\\ndata = []\\nfor i in range(10):\\n    chunk = 'x' * (8 * 1024 * 1024)\\n    data.append(chunk)\\n    print(f'Loaded chunk {i+1}/10 (~{(i+1)*8}MB in memory)')\\n    time.sleep(1)\\n\\nprint('Data loaded successfully!')\\nprint('Processing data...')\\n\\nwhile True:\\n    print('Processing batch...')\\n    time.sleep(10)\\n\\\"\\n\"],\"command\":[\"/bin/sh\"],\"env\":[{\"name\":\"PYTHONUNBUFFERED\",\"value\":\"1\"}],\"image\":\"python:3.11-slim\",\"imagePullPolicy\":\"IfNotPresent\",\"name\":\"processor\",\"resources\":{\"limits\":{\"cpu\":\"200m\",\"memory\":\"90Mi\"},\"requests\":{\"cpu\":\"100m\",\"memory\":\"32Mi\"}},\"terminationMessagePath\":\"/dev/termination-log\",\"terminationMessagePolicy\":\"File\"}],\"dnsPolicy\":\"ClusterFirst\",\"restartPolicy\":\"Always\",\"schedulerName\":\"default-scheduler\",\"securityContext\":{},\"terminationGracePeriodSeconds\":30}}},\"status\":{\"conditions\":[{\"lastTransitionTime\":\"2026-06-16T08:22:44Z\",\"lastUpdateTime\":\"2026-06-16T08:22:45Z\",\"message\":\"ReplicaSet \\\"data-processor-d66fc797f\\\" has successfully progressed.\",\"reason\":\"NewReplicaSetAvailable\",\"status\":\"True\",\"type\":\"Progressing\"},{\"lastTransitionTime\":\"2026-06-17T04:25:23Z\",\"lastUpdateTime\":\"2026-06-17T04:25:23Z\",\"message\":\"Deployment does not have minimum availability.\",\"reason\":\"MinimumReplicasUnavailable\",\"status\":\"False\",\"type\":\"Available\"}],\"observedGeneration\":1,\"replicas\":1,\"terminatingReplicas\":0,\"unavailableReplicas\":1,\"updatedReplicas\":1}}\n"},"creationTimestamp":"2026-06-16T08:22:44Z","resourceVersion":"1249459","uid":"e766c00d-632a-4529-bf9a-d6dde837f142"},"spec":{"template":{"spec":{"$setElementOrder/containers":[{"name":"processor"}],"containers":[{"name":"processor","resources":{"limits":{"memory":"90Mi"}}}]}}},"status":{"$setElementOrder/conditions":[{"type":"Progressing"},{"type":"Available"}],"conditions":[{"lastTransitionTime":"2026-06-16T08:22:44Z","lastUpdateTime":"2026-06-16T08:22:45Z","message":"ReplicaSet \"data-processor-d66fc797f\" has successfully progressed.","type":"Progressing"},{"lastTransitionTime":"2026-06-17T04:25:23Z","lastUpdateTime":"2026-06-17T04:25:23Z","message":"Deployment does not have minimum availability.","reason":"MinimumReplicasUnavailable","status":"False","type":"Available"}],"unavailableReplicas":1}}
to:
Resource: "apps/v1, Resource=deployments", GroupVersionKind: "apps/v1, Kind=Deployment"
Name: "data-processor", Namespace: "pod-evicted"
for: "data-processor-5b64d56fc4-bkpm7.yaml": error when patching "data-processor-5b64d56fc4-bkpm7.yaml": Operation cannot be fulfilled on deployments.apps "data-processor": the object has been modified; please apply your changes to the latest version and try again
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl apply -f data-processor-5b64d56fc4-bkpm7.yaml --force
deployment.apps/data-processor configured


```

- Now this solved our issue after making  changes to 90MB

``` bash

[root@rhel9-4gb ~]# kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
data-processor-57bd988b5d-6v5bg   1/1     Running   0          78s
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl logs data-processor-57bd988b5d-6v5bg
==========================================
Data Processor Starting...
==========================================
Allocating memory for data processing...
Loading data into memory...
Loaded chunk 1/10 (~8MB in memory)
Loaded chunk 2/10 (~16MB in memory)
Loaded chunk 3/10 (~24MB in memory)
Loaded chunk 4/10 (~32MB in memory)
Loaded chunk 5/10 (~40MB in memory)
Loaded chunk 6/10 (~48MB in memory)
Loaded chunk 7/10 (~56MB in memory)
Loaded chunk 8/10 (~64MB in memory)
Loaded chunk 9/10 (~72MB in memory)
Loaded chunk 10/10 (~80MB in memory)
Data loaded successfully!
Processing data...
Processing batch...
Processing batch...
Processing batch...
Processing batch...
Processing batch...
Processing batch...
Processing batch...
Processing batch...

```



