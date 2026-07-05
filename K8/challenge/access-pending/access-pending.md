


```
rhel9-4gb ~]# kubeasy challenge start access-pending


# Starting Challenge: access-pending

 SUCCESS  Fetching challenge details
 INFO  Challenge: Access Pending
 SUCCESS  Checking challenge progress

 SUCCESS  Creating namespace
 SUCCESS  Deploying challenge
 SUCCESS  Kubectl context configured
 SUCCESS  Registering challenge progress

 SUCCESS  Challenge environment is ready!
Challenge: access-pending
Namespace: access-pending
Context: kind-kubeasy

 INFO  You can now start working on the challenge!

```

```bash
[root@rhel9-4gb ~]# kubectl get pod
NAME                           READY   STATUS    RESTARTS   AGE
startup-app-7fdff84945-df5vc   1/1     Running   0          2m5s
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl describe startup-app-7fdff84945-df5vc
error: the server doesn't have a resource type "startup-app-7fdff84945-df5vc"
[root@rhel9-4gb ~]# kubectl describe po startup-app-7fdff84945-df5vc
Name:             startup-app-7fdff84945-df5vc
Namespace:        access-pending
Priority:         0
Service Account:  startup-checker
Node:             kubeasy-control-plane/172.18.0.2
Start Time:       Thu, 25 Jun 2026 06:31:01 +0000
Labels:           app=startup-app
                  pod-template-hash=7fdff84945
Annotations:      <none>
Status:           Running
IP:               10.244.0.13
IPs:
  IP:           10.244.0.13
Controlled By:  ReplicaSet/startup-app-7fdff84945
Containers:
  startup-app:
    Container ID:   containerd://525fe8a82e5d068ff6b7926b6e3c200fba74c1a42df1ba00d314a2344f199e29
    Image:          ghcr.io/kubeasy-dev/registry/access-pending:latest
    Image ID:       ghcr.io/kubeasy-dev/registry/access-pending@sha256:fdfc8d4f59f13f0a94c2581edcd8a0b442821947f7473c98890dbe7f2c41c454
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 25 Jun 2026 06:31:02 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     200m
      memory:  256Mi
    Requests:
      cpu:      100m
      memory:   128Mi
    Readiness:  http-get http://:8080/healthz delay=3s timeout=1s period=5s #success=1 #failure=3
    Environment:
      POD_NAMESPACE:  access-pending (v1:metadata.namespace)
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-htt9x (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-htt9x:
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
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m22s  default-scheduler  Successfully assigned access-pending/startup-app-7fdff84945-df5vc to kubeasy-control-plane
  Normal  Pulled     2m22s  kubelet            Container image "ghcr.io/kubeasy-dev/registry/access-pending:latest" already present on machine and can be accessed by the pod
  Normal  Created    2m22s  kubelet            Container created
  Normal  Started    2m21s  kubelet            Container started
[root@rhel9-4gb ~]# ll -ld /var/run/secrets/kubernetes.io/serviceaccount
ls: cannot access '/var/run/secrets/kubernetes.io/serviceaccount': No such file or directory
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl logs startup-app-7fdff84945-df5vc
2026/06/25 06:31:02 Starting startup-checker
2026/06/25 06:31:02 Listening on :8080
2026/06/25 06:31:02 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:31:12 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:31:22 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:31:32 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:31:42 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:31:52 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:32:02 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:32:12 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:32:22 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace "access-pending"
2026/06/25 06:32:32 Access denied listing pods in access-pending: pods is forbidden: User "system:serviceaccount:access-pending:startup-checker" cannot list resource "pods" in API group "" in the namespace

```


```bash

[root@rhel9-4gb ~]# kubectl get role
NAME                 CREATED AT
startup-check-role   2026-06-25T06:31:01Z
[root@rhel9-4gb ~]#

[root@rhel9-4gb ~]# kubectl describe role startup-check-role
Name:         startup-check-role
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  pods       []                 []              [get]


```


```bash

~]# kubectl get roles  startup-check-role -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: "2026-07-05T14:15:32Z"
  name: startup-check-role
  namespace: access-pending
  resourceVersion: "7076874"
  uid: 8cec482c-b849-4de8-adad-66ada8697e9e
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
```

```bash 

[root@rhel9-4gb ~]# kubectl auth can-i list pods  --as=system:serviceaccount:access-pending:startup-checker
no

[root@rhel9-4gb ~]# kubectl auth can-i get pods  --as=system:serviceaccount:access-pending:startup-checker
yes

~]# kubectl get roles  startup-check-role -o yaml > role.yaml

```

```bash

~]# vi role.yaml
~]# cat role.yaml
~]# cat role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: startup-check-role
  namespace: access-pending
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list

[root@rhel9-4gb ~]# kubectl auth can-i  list pods --as=system:serviceaccount:access-pending:startup-checker
no
[root@rhel9-4gb ~]# kubectl apply -f role.yaml
Warning: resource roles/startup-check-role is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
role.rbac.authorization.k8s.io/startup-check-role configured
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubectl auth can-i  list pods --as=system:serviceaccount:access-pending:startup-checker
yes
[root@rhel9-4gb ~]#

[root@rhel9-4gb ~]# kubectl logs startup-app-7fdff84945-7kzxx|tail -5
2026/07/05 16:09:14 Access OK
2026/07/05 16:09:24 Access OK
2026/07/05 16:09:34 Access OK
2026/07/05 16:09:44 Access OK
2026/07/05 16:09:54 Access OK

```

```

[root@rhel9-4gb ~]# kubeasy challenge submit access-pending


# Submitting Challenge: access-pending

 SUCCESS  Verifying challenge
 SUCCESS  Checking progress
 SUCCESS  Loading validations
 INFO  Running validations...



# Condition Validation

 SUCCESS  pod-ready-check: All checks passed
  ✓ All checks passed



# Status Validation

 SUCCESS  pod-stable-check: All checks passed
  ✓ All status checks passed



# Log Validation

 SUCCESS  pod-logs-check: All checks passed
  ✓ Found all expected strings in logs



# RBAC Validation

 SUCCESS  rbac-check: All checks passed
  ✓ All RBAC checks passed



# Submission Result

 SUCCESS  All validations passed!

 SUCCESS  Congratulations! Challenge 'access-pending' completed!
 INFO  You can clean up with 'kubeasy challenge clean access-pending'
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]#
[root@rhel9-4gb ~]# kubeasy challenge clean access-pending


# Cleaning Challenge: access-pending


 SUCCESS  Deleting challenge resources (completed in 0s)
 SUCCESS  Challenge resources deleted

 SUCCESS  Challenge 'access-pending' cleaned successfully!
 INFO  All resources have been removed from your cluster
[root@rhel9-4gb ~]#

```
