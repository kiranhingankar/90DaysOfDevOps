# Day 50 - Kubernetes Architecture and Cluster Setup

## Introduction

Today I started my Kubernetes journey by learning how Kubernetes works internally and setting up a local Kubernetes cluster using kind (Kubernetes IN Docker). I explored the Kubernetes architecture, understood the role of the control plane and worker node components, and used kubectl commands to inspect the cluster and its running system pods.

---

# Task 1 - Kubernetes Story

## Why Was Kubernetes Created?

Docker is excellent for creating and running containers, but managing containers manually becomes very difficult at scale.

Problems with Docker alone:
- No automatic scaling
- No self-healing if containers crash
- Difficult networking across multiple servers
- No automatic load balancing
- Hard to manage hundreds of containers

Kubernetes was created to solve container orchestration problems by automating:
- Deployment
- Scaling
- Networking
- Load balancing
- Self-healing
- Container scheduling

Kubernetes helps manage containers across multiple machines efficiently.

---

## Who Created Kubernetes?

Kubernetes was created by Google and inspired by Google's internal container orchestration platform called Borg.

Google had years of experience managing containers at massive scale before open-sourcing Kubernetes.

---

## What Does Kubernetes Mean?

The word Kubernetes comes from Greek.

Meaning:
- Helmsman
- Pilot
- Captain of a ship

Short form:
- K8s

The Kubernetes logo is inspired by a ship wheel.

---

# Task 2 - Kubernetes Architecture

## Kubernetes Architecture Diagram

```text
                           +----------------------+
                           |      kubectl CLI     |
                           +----------+-----------+
                                      |
                                      v
                           +----------------------+
                           |      API Server      |
                           +----------+-----------+
                                      |
         +----------------------------+----------------------------+
         |                            |                            |
         v                            v                            v
+-------------------+     +-------------------+     +------------------------+
|       etcd        |     |     Scheduler     |     |   Controller Manager   |
+-------------------+     +-------------------+     +------------------------+

=========================================================================

                           WORKER NODE 1

+-----------------------------------------------------------------------+
| kubelet | kube-proxy | container runtime | Running Pods/Containers    |
+-----------------------------------------------------------------------+

                           WORKER NODE 2

+-----------------------------------------------------------------------+
| kubelet | kube-proxy | container runtime | Running Pods/Containers    |
+-----------------------------------------------------------------------+
```

---

# Control Plane Components

## 1. API Server

The API Server is the front door of the Kubernetes cluster.

Responsibilities:
- Receives all kubectl requests
- Validates requests
- Communicates with cluster components
- Stores cluster state in etcd

Every command passes through the API server.

Example:
```bash
kubectl get pods
```

---

## 2. etcd

etcd is the distributed key-value database of Kubernetes.

Responsibilities:
- Stores cluster state
- Stores pod configurations
- Stores secrets and configs
- Stores node information

If etcd data is lost, the cluster state is lost.

---

## 3. Scheduler

The Scheduler decides where pods should run.

Responsibilities:
- Checks node resources
- Finds the best node
- Assigns pods to worker nodes

Example:
If a new pod is created, the scheduler selects a suitable worker node with enough CPU and memory.

---

## 4. Controller Manager

The Controller Manager continuously watches the cluster state.

Responsibilities:
- Maintains desired state
- Recreates failed pods
- Handles replication
- Performs self-healing

Example:
Desired State:
```text
3 nginx pods
```

Actual State:
```text
2 nginx pods
```

Controller Manager creates the missing pod automatically.

---

# Worker Node Components

## 1. kubelet

kubelet is the agent running on every worker node.

Responsibilities:
- Talks to API server
- Starts and stops pods
- Reports node health
- Ensures containers are running

---

## 2. kube-proxy

kube-proxy manages networking inside the cluster.

Responsibilities:
- Maintains networking rules
- Enables pod-to-pod communication
- Handles service routing

---

## 3. Container Runtime

The Container Runtime actually runs containers.

Examples:
- containerd
- CRI-O

Responsibilities:
- Pull container images
- Start containers
- Stop containers

---

# What Happens When Running kubectl apply?

Command:
```bash
kubectl apply -f pod.yaml
```

## Flow

### Step 1
kubectl sends request to API Server.

### Step 2
API Server validates the request.

### Step 3
API Server stores desired state in etcd.

### Step 4
Scheduler selects the best worker node.

### Step 5
kubelet receives instructions from API Server.

### Step 6
Container runtime pulls image and starts container.

### Step 7
Controller Manager continuously monitors the pod.

---

# What Happens If API Server Goes Down?

- Existing applications continue running
- No new deployments can happen
- kubectl commands stop working
- Cluster management becomes unavailable

Because API Server is the entry point of Kubernetes.

---

# What Happens If Worker Node Goes Down?

Kubernetes detects the node failure.

Controller Manager and Scheduler:
- Mark node unhealthy
- Reschedule pods on healthy nodes

This is Kubernetes self-healing capability.

---

# Task 3 - Install kubectl

## Install kubectl on Windows

Using Chocolatey:

```powershell
choco install kubernetes-cli
```

---

## Verify Installation

```powershell
kubectl version --client
```

Expected Output:
```text
Client Version: v1.xx.x
```

---

# Task 4 - Set Up Local Kubernetes Cluster

## Tool Chosen

I chose kind (Kubernetes IN Docker).

### Why I Chose kind
- Lightweight
- Fast startup
- Uses Docker containers as Kubernetes nodes
- Perfect for learning and local development
- Easy to create and delete clusters

---

# Install kind

Using Chocolatey:

```powershell
choco install kind
```

---

# Verify kind Installation

```powershell
kind version
```

---

# Create Kubernetes Cluster

```powershell
kind create cluster --name devops-cluster
```

Expected Output:
```text
Creating cluster "devops-cluster" ...
Ensuring node image ...
Preparing nodes ...
Writing configuration ...
Starting control-plane ...
Installing CNI ...
Installing StorageClass ...
Set kubectl context to "kind-devops-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-devops-cluster
```

---

# Verify Cluster

## Cluster Info

```powershell
kubectl cluster-info
```

Expected Output:
```text
Kubernetes control plane is running at https://127.0.0.1:xxxxx
CoreDNS is running at https://127.0.0.1:xxxxx/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

---

## Get Nodes

```powershell
kubectl get nodes
```

Example Output:
```text
NAME                            STATUS   ROLES           AGE   VERSION
devops-cluster-control-plane   Ready    control-plane   2m    v1.33.x
```

---

# Screenshot Section

## Screenshot - kubectl get nodes

```text
[ Add Screenshot Here ]
```

---

# Task 5 - Explore the Cluster

## Get Cluster Info

```powershell
kubectl cluster-info
```

---

## List All Nodes

```powershell
kubectl get nodes
```

---

## Get Detailed Node Information

```powershell
kubectl describe node devops-cluster-control-plane
```

---

## List Namespaces

```powershell
kubectl get namespaces
```

Example Output:
```text
NAME              STATUS   AGE
default           Active   10m
kube-node-lease   Active   10m
kube-public       Active   10m
kube-system       Active   10m
```

---

## List All Pods

```powershell
kubectl get pods -A
```

---

## View kube-system Pods

```powershell
kubectl get pods -n kube-system
```

Example Output:
```text
NAME                                                    READY   STATUS    RESTARTS   AGE
coredns-668d6bf9bc-abcde                               1/1     Running   0          5m
etcd-devops-cluster-control-plane                      1/1     Running   0          5m
kindnet-abcdef                                         1/1     Running   0          5m
kube-apiserver-devops-cluster-control-plane            1/1     Running   0          5m
kube-controller-manager-devops-cluster-control-plane   1/1     Running   0          5m
kube-proxy-abcde                                       1/1     Running   0          5m
kube-scheduler-devops-cluster-control-plane            1/1     Running   0          5m
```

---

# Screenshot - kube-system Pods

```text
[ Add Screenshot Here ]
```

---

# What Each kube-system Pod Does

| Pod | Purpose |
|------|----------|
| etcd | Stores cluster state |
| kube-apiserver | Front door of Kubernetes |
| kube-scheduler | Assigns pods to nodes |
| kube-controller-manager | Maintains desired state |
| kube-proxy | Handles networking |
| coredns | Internal cluster DNS |
| kindnet | Provides cluster networking |

---

# Match Architecture Components with Running Pods

| Architecture Component | Running Pod |
|------------------------|-------------|
| API Server | kube-apiserver |
| etcd | etcd |
| Scheduler | kube-scheduler |
| Controller Manager | kube-controller-manager |
| kube-proxy | kube-proxy |
| DNS | coredns |

---

# Task 6 - Practice Cluster Lifecycle

## Delete Cluster

```powershell
kind delete cluster --name devops-cluster
```

Expected Output:
```text
Deleting cluster "devops-cluster" ...
Deleted nodes: ["devops-cluster-control-plane"]
```

---

## Recreate Cluster

```powershell
kind create cluster --name devops-cluster
```

---

## Verify Cluster is Running Again

```powershell
kubectl get nodes
```

---

# Kubernetes Context Commands

## Current Context

```powershell
kubectl config current-context
```

Example Output:
```text
kind-devops-cluster
```

---

## List All Contexts

```powershell
kubectl config get-contexts
```

---

## View kubeconfig

```powershell
kubectl config view
```

---

# What is kubeconfig?

kubeconfig is the configuration file used by kubectl to connect to Kubernetes clusters.

It stores:
- Cluster information
- Authentication details
- User credentials
- Contexts
- API server endpoints

---

# kubeconfig Location

## Windows
```text
C:\Users\<username>\.kube\config
```

## Linux/macOS
```text
~/.kube/config
```

---

# Important Kubernetes Commands Learned

```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
kubectl get pods -n kube-system
kubectl describe node <node-name>
kubectl get namespaces
kubectl config current-context
kubectl config get-contexts
kubectl config view
kind create cluster --name devops-cluster
kind delete cluster --name devops-cluster
```

---

# Troubleshooting

## Docker Not Running

Error:
```text
Cannot connect to Docker daemon
```

Solution:
- Start Docker Desktop

---

## kubectl Cannot Connect

Check clusters:
```powershell
kind get clusters
```

---

## Node Not Ready

Wait a few seconds:
```powershell
kubectl get nodes
```

Cluster initialization may take some time.

---

# Learning Summary

Today I learned:
- Why Kubernetes was created
- Kubernetes architecture
- Control Plane components
- Worker Node components
- How kubectl communicates with the cluster
- How to create and manage a local Kubernetes cluster
- How to inspect kube-system pods
- What kubeconfig is and where it is stored

I also explored how Kubernetes automatically manages containers and provides self-healing and orchestration features beyond Docker.

---

# Conclusion

Kubernetes is a powerful container orchestration platform that automates deployment, scaling, networking, and recovery of containerized applications.

Today marked the beginning of my Kubernetes journey by setting up a local cluster, understanding cluster architecture, and exploring the internal system components running inside the cluster.

This foundation will help in learning:
- Deployments
- Services
- Ingress
- Helm
- Monitoring
- CI/CD
- Production Kubernetes

---