# Kubernetes Core Component Flow

## High-Level Architecture

```text
                    kubectl
                        |
                        v
                 API Server
                        |
                        v
                     etcd
                        |
          +-------------+-------------+
          |                           |
          v                           v
 Controller Manager             Scheduler
          |                           |
          +-------------+-------------+
                        |
                        v
                    Kubelet
                        |
                        v
                   containerd
                        |
                        v
                  Linux Kernel
                        |
                        v
                    Processes


Worker Node Components
----------------------

+--------------------------------------+
| Worker Node                          |
|                                      |
|  Kubelet                             |
|     |                                |
|     v                                |
|  containerd                          |
|     |                                |
|     v                                |
|  Pods / Containers                   |
|                                      |
|  kube-proxy                          |
|     |                                |
|     +--> iptables / IPVS rules       |
|                                      |
+--------------------------------------+
```

---

# Component Breakdown

## 1. kubectl

**Purpose:** Kubernetes command-line client.

Used to interact with the cluster.

Example:

```bash
kubectl get pods
kubectl apply -f deployment.yaml
kubectl delete pod nginx
```

### Responsibility

* Sends requests to the API Server.
* Does not directly communicate with worker nodes.
* Does not start containers.

---

## 2. API Server

**Component:** `kube-apiserver`

The central entry point for the Kubernetes cluster.

Everything communicates through the API Server:

* kubectl
* Controllers
* Scheduler
* Kubelets

### Responsibility

* Validates requests.
* Authenticates users.
* Stores cluster state in etcd.
* Exposes Kubernetes APIs.

Without the API Server, the cluster cannot function.

---

## 3. etcd

**Component:** `etcd`

Distributed key-value database.

Stores the entire cluster state.

### Examples of Stored Data

* Pods
* Deployments
* Services
* ConfigMaps
* Secrets
* Nodes

### Responsibility

Acts as the cluster's source of truth.

Without etcd:

* Cluster loses its memory.
* Desired state cannot be recovered.

---

## 4. Controller Manager

**Component:** `kube-controller-manager`

Continuously compares:

```text
Desired State
      vs
Actual State
```

### Example

Desired:

```text
3 nginx pods
```

Actual:

```text
2 nginx pods
```

Controller action:

```text
Create 1 additional pod
```

### Responsibility

Provides self-healing behavior.

Examples:

* ReplicaSet Controller
* Deployment Controller
* Node Controller
* Job Controller

---

## 5. Scheduler

**Component:** `kube-scheduler`

Decides where Pods should run.

### Example

New Pod created:

```text
Pod -> ?
```

Scheduler selects:

```text
Pod -> Node-A
```

based on:

* Available CPU
* Available Memory
* Node Affinity
* Taints and Tolerations
* Resource Requests

### Responsibility

Assigns Pods to nodes.

Without Scheduler:

Pods remain in `Pending` state.

---

## 6. Kubelet

Runs on every worker node.

Acts as the node agent.

### Responsibility

* Watches for assigned Pods.
* Communicates with the API Server.
* Ensures containers are running.
* Reports node and Pod status.

### Example

API Server says:

```text
Run nginx pod
```

Kubelet receives instruction and executes it.

Without Kubelet:

Nodes cannot run workloads.

---

## 7. containerd

Container runtime.

Responsible for managing containers.

### Responsibility

* Pull images
* Create containers
* Start containers
* Stop containers
* Delete containers

### Example

Kubelet requests:

```text
Start nginx container
```

containerd performs the container lifecycle operations.

---

## 8. Linux Kernel

The actual operating system kernel.

Kubernetes does not run applications directly.

Linux does.

### Responsibility

Provides:

* Processes
* Namespaces
* Cgroups
* Networking
* Filesystems
* Memory Management

Container runtimes ultimately use Linux kernel features.

---

## 9. Processes

Final destination of every Kubernetes workload.

Example:

```text
nginx
java
python
nodejs
```

These are ordinary Linux processes.

### Important Principle

A container is not a virtual machine.

A container is:

```text
Process
+
Namespaces
+
Cgroups
+
Filesystem
```

---

# End-to-End Example

User executes:

```bash
kubectl apply -f nginx.yaml
```

### Step 1

kubectl sends a request to the API Server.

### Step 2

API Server validates the request.

### Step 3

API Server stores the desired state in etcd.

### Step 4

Controller Manager notices:

```text
Desired: 3 Pods
Actual: 0 Pods
```

### Step 5

Controller creates Pod objects.

### Step 6

Scheduler assigns Pods to worker nodes.

```text
Pod-1 -> Node-A
Pod-2 -> Node-B
Pod-3 -> Node-C
```

### Step 7

Kubelet on each node observes assigned Pods.

### Step 8

Kubelet instructs containerd.

### Step 9

containerd creates containers.

### Step 10

Linux Kernel starts application processes.

### Step 11

Kubelet reports status back to API Server.

Result:

```text
Desired State = Actual State
```

Application is now running.

