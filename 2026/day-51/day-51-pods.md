# Day 51 – Kubernetes Manifests and Your First Pods ☸️

## Introduction

Today I learned how Kubernetes Pods work and how to create them using YAML manifests.

This was my first hands-on experience writing Kubernetes manifests from scratch, deploying Pods, debugging containers, and understanding the difference between declarative and imperative Kubernetes workflows.

---

# What is a Kubernetes Manifest?

A Kubernetes manifest is a YAML file that describes the desired state of a Kubernetes resource.

Kubernetes reads this YAML file and creates the resource automatically.

Every Kubernetes manifest contains four important top-level fields:

```yaml
apiVersion:
kind:
metadata:
spec:
```

---

# The Four Required Fields of a Kubernetes Manifest

## 1. apiVersion

Defines which Kubernetes API version should be used.

Example:

```yaml
apiVersion: v1
```

Pods use:
- `v1`

Other resources may use:
- `apps/v1`
- `batch/v1`

---

## 2. kind

Defines the type of Kubernetes resource.

Example:

```yaml
kind: Pod
```

Other examples:
- Deployment
- Service
- ConfigMap

---

## 3. metadata

Contains identifying information about the resource.

Example:

```yaml
metadata:
  name: nginx-pod
  labels:
    app: nginx
```

Metadata can include:
- name
- labels
- namespace

---

## 4. spec

Defines the desired state of the resource.

Example:

```yaml
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

This tells Kubernetes:
- which container to run
- which image to pull
- which ports to expose

---

# Task 1 – Nginx Pod

## nginx-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

---

## Apply the Manifest

```bash
kubectl apply -f nginx-pod.yaml
```

---

## Verify Pod

```bash
kubectl get pods
kubectl get pods -o wide
```

---

## Describe Pod

```bash
kubectl describe pod nginx-pod
```

---

## View Logs

```bash
kubectl logs nginx-pod
```

---

## Enter the Container

```bash
kubectl exec -it nginx-pod -- /bin/bash
```

If bash is unavailable:

```bash
kubectl exec -it nginx-pod -- /bin/sh
```

---

## Test Nginx Inside the Container

```bash
curl localhost:80
```

Expected Output:

```html
Welcome to nginx!
```

---

# Task 2 – BusyBox Pod

## busybox-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
    environment: dev
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh", "-c", "echo Hello from BusyBox && sleep 3600"]
```

---

# Why Use sleep 3600?

BusyBox containers exit immediately unless a long-running process exists.

Without the sleep command:
- the container exits
- the pod crashes
- Kubernetes restarts it continuously

This results in:
- `CrashLoopBackOff`

---

## Apply the Manifest

```bash
kubectl apply -f busybox-pod.yaml
```

---

## Verify

```bash
kubectl get pods
```

---

## View Logs

```bash
kubectl logs busybox-pod
```

Expected Output:

```bash
Hello from BusyBox
```

---

# Task 3 – Third Pod Manifest

## alpine-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: alpine-pod
  labels:
    app: alpine
    environment: testing
    team: devops
spec:
  containers:
  - name: alpine
    image: alpine:latest
    command: ["sh", "-c", "sleep 3600"]
```

---

## Apply the Manifest

```bash
kubectl apply -f alpine-pod.yaml
```

---

# Imperative vs Declarative Kubernetes

## Imperative Approach

Create resources directly using commands.

Example:

```bash
kubectl run redis-pod --image=redis:latest
```

Advantages:
- quick testing
- faster for temporary resources

Disadvantages:
- hard to track changes
- not ideal for production
- not reusable

---

## Declarative Approach

Define infrastructure using YAML files.

Example:

```bash
kubectl apply -f nginx-pod.yaml
```

Advantages:
- reusable
- version controlled
- easier automation
- Infrastructure as Code
- preferred for production

---

# Generate YAML Using Dry Run

Generate YAML without creating the Pod:

```bash
kubectl run test-pod --image=nginx --dry-run=client -o yaml
```

Save output:

```bash
kubectl run test-pod --image=nginx --dry-run=client -o yaml > test-pod.yaml
```

---

# Validate Before Applying

## Client Side Validation

```bash
kubectl apply -f nginx-pod.yaml --dry-run=client
```

---

## Server Side Validation

```bash
kubectl apply -f nginx-pod.yaml --dry-run=server
```

---

# Error When Image Field is Missing

If the image field is removed:

```yaml
image: nginx:latest
```

Kubernetes returns:

```bash
spec.containers[0].image: Required value
```

This means every container must have an image.

---

# Pod Labels and Filtering

## Show Labels

```bash
kubectl get pods --show-labels
```

---

## Filter Pods Using Labels

Filter nginx pods:

```bash
kubectl get pods -l app=nginx
```

Filter development environment pods:

```bash
kubectl get pods -l environment=dev
```

Filter by team:

```bash
kubectl get pods -l team=devops
```

---

# Add Labels Dynamically

```bash
kubectl label pod nginx-pod environment=production
```

---

# Remove Labels

```bash
kubectl label pod nginx-pod environment-
```

---

# Useful Kubernetes Commands

## Get Pods

```bash
kubectl get pods
```

---

## Detailed Pod Information

```bash
kubectl describe pod nginx-pod
```

---

## View Logs

```bash
kubectl logs nginx-pod
```

---

## Execute Commands Inside Container

```bash
kubectl exec -it nginx-pod -- /bin/sh
```

---

## Delete Pod

```bash
kubectl delete pod nginx-pod
```

---

# What Happens When You Delete a Standalone Pod?

When a standalone Pod is deleted:
- it is permanently removed
- Kubernetes does not recreate it automatically

Reason:
- no controller manages the Pod

In production environments, Deployments are used instead of standalone Pods because Deployments automatically recreate failed or deleted Pods.

---

# Screenshot of Running Pods

Add screenshot here:

```text
[screenshot-of-kubectl-get-pods]
```

Example:

```bash
NAME           READY   STATUS    RESTARTS   AGE
nginx-pod      1/1     Running   0          5m
busybox-pod    1/1     Running   0          4m
alpine-pod     1/1     Running   0          3m
redis-pod      1/1     Running   0          2m
```

---

# Folder Structure

```text
2026/
└── day-51/
    ├── nginx-pod.yaml
    ├── busybox-pod.yaml
    ├── alpine-pod.yaml
    ├── test-pod.yaml
    ├── screenshot.png
    └── day-51-pods.md
```

---

# Git Commands

```bash
git add .
git commit -m "Day 51 Kubernetes Pods and manifests"
git push origin main
```

---

# Key Learnings 🚀

✅ Learned Kubernetes Pod manifests  
✅ Understood YAML structure  
✅ Created Pods manually  
✅ Learned imperative vs declarative Kubernetes  
✅ Used kubectl logs, describe, and exec  
✅ Worked with labels and selectors  
✅ Understood Pod lifecycle behavior  

---

# Conclusion

Today was my first real hands-on experience with Kubernetes Pods and manifests.

I learned how Kubernetes uses YAML files to manage infrastructure declaratively and how Pods behave inside a cluster.

This was an important step toward understanding Deployments, Services, scaling, and production-grade Kubernetes workloads.

---