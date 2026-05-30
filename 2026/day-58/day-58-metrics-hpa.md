# Day 58 – Metrics Server and Horizontal Pod Autoscaler (HPA)

## Objective

The goal of this lab is to install the Kubernetes Metrics Server, collect resource usage metrics from cluster nodes and pods, and configure a Horizontal Pod Autoscaler (HPA) that automatically scales an application based on CPU utilization.

By the end of this exercise, you will:

* Install and verify Metrics Server on a KIND cluster
* Use `kubectl top` to monitor resource consumption
* Deploy a CPU-intensive application
* Configure HPA using both imperative and declarative methods
* Generate load and observe automatic scaling
* Understand how Kubernetes calculates desired replicas
* Learn the differences between `autoscaling/v1` and `autoscaling/v2`

---

# Prerequisites

* Docker installed
* KIND cluster running
* kubectl configured

Verify cluster:

```bash
kubectl get nodes
```

Example output:

```text
NAME                 STATUS   ROLES           AGE
kind-control-plane   Ready    control-plane   5d
```

---

# What is Metrics Server?

Metrics Server is a lightweight cluster-wide aggregator of resource usage data.

It collects:

* CPU usage
* Memory usage

from each node's kubelet and exposes those metrics through the Kubernetes Metrics API.

Metrics Server enables:

* `kubectl top`
* Horizontal Pod Autoscaler (HPA)
* Vertical Pod Autoscaler (VPA)

Without Metrics Server, Kubernetes cannot make scaling decisions based on resource consumption.

---

# Why HPA Needs Metrics Server

Horizontal Pod Autoscaler relies on real-time metrics.

Workflow:

```text
Application
     │
     ▼
CPU Usage Increases
     │
     ▼
Metrics Server
     │
     ▼
Metrics API
     │
     ▼
Horizontal Pod Autoscaler
     │
     ▼
Scale Deployment
```

If Metrics Server is unavailable:

```text
kubectl top nodes
```

fails and HPA shows:

```text
<unknown>
```

for utilization targets.

---

# Task 1: Install Metrics Server

## Check Existing Installation

```bash
kubectl get pods -n kube-system | grep metrics-server
```

If Metrics Server is not running, install it.

---

## Install Metrics Server

Apply the official manifest:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify installation:

```bash
kubectl get pods -n kube-system
```

Expected:

```text
metrics-server-xxxxx   Running
```

---

## KIND Cluster TLS Fix

Metrics Server often requires an insecure TLS option on local KIND clusters.

Edit deployment:

```bash
kubectl edit deployment metrics-server -n kube-system
```

Locate:

```yaml
args:
```

Add:

```yaml
- --kubelet-insecure-tls
```

Example:

```yaml
args:
  - --cert-dir=/tmp
  - --secure-port=10250
  - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
  - --kubelet-use-node-status-port
  - --metric-resolution=15s
  - --kubelet-insecure-tls
```

Save and exit.

---

## Verify Rollout

```bash
kubectl rollout status deployment metrics-server -n kube-system
```

Wait approximately 60 seconds for metrics collection.

---

# Verify Metrics Collection

Node metrics:

```bash
kubectl top nodes
```

Example:

```text
NAME                 CPU(cores)   CPU%
kind-control-plane   120m         6%
```

Pod metrics:

```bash
kubectl top pods -A
```

Example:

```text
NAMESPACE      NAME             CPU   MEMORY
kube-system    metrics-server   3m    40Mi
```

---

## Current Resource Usage

Record your cluster values:

### Node CPU Usage

```text
<your output here>
```

### Node Memory Usage

```text
<your output here>
```

---

# Task 2: Exploring kubectl top

Display node usage:

```bash
kubectl top nodes
```

Display pod usage:

```bash
kubectl top pods -A
```

Sort by CPU:

```bash
kubectl top pods -A --sort-by=cpu
```

The pod at the top of the list is currently consuming the most CPU resources.

---

## Requests vs Limits vs Usage

### Resource Requests

Guaranteed resources.

```yaml
resources:
  requests:
    cpu: 200m
```

### Resource Limits

Maximum resources allowed.

```yaml
resources:
  limits:
    cpu: 500m
```

### Actual Usage

Reported by:

```bash
kubectl top
```

Actual usage continuously changes based on workload.

---

# Task 3: Create CPU-Intensive Deployment

Create:

```bash
nano php-apache.yaml
```

Manifest:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: php-apache
  template:
    metadata:
      labels:
        app: php-apache
    spec:
      containers:
      - name: php-apache
        image: registry.k8s.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 200m
```

Apply:

```bash
kubectl apply -f php-apache.yaml
```

Verify:

```bash
kubectl get pods
```

Expected:

```text
php-apache-xxxxx   Running
```

---

# Create Service

Expose deployment:

```bash
kubectl expose deployment php-apache --port=80
```

Verify:

```bash
kubectl get svc
```

Expected:

```text
php-apache   ClusterIP
```

---

# Check Current CPU Usage

Find pod:

```bash
kubectl get pods
```

Check usage:

```bash
kubectl top pod <pod-name>
```

Example:

```text
NAME         CPU(cores)   MEMORY(bytes)
php-apache   1m           10Mi
```

### Verification

Current CPU Usage:

```text
<your output here>
```

---

# Task 4: Create HPA (Imperative)

Create autoscaler:

```bash
kubectl autoscale deployment php-apache \
  --cpu-percent=50 \
  --min=1 \
  --max=10
```

Verify:

```bash
kubectl get hpa
```

Example:

```text
NAME         REFERENCE               TARGETS   MINPODS MAXPODS REPLICAS
php-apache   Deployment/php-apache   1%/50%    1       10      1
```

Initially:

```text
<unknown>/50%
```

may appear while metrics are being collected.

---

## Describe HPA

```bash
kubectl describe hpa php-apache
```

Important section:

```text
Metrics:
resource cpu
target average utilization: 50%
```

---

## Verification

TARGETS Column:

```text
<your output here>
```

---

# How HPA Calculates Desired Replicas

Formula:

```text
desiredReplicas = ceil(currentReplicas × (currentUsage / targetUsage))
```

Example:

Current Replicas:

```text
1
```

Current CPU Utilization:

```text
120%
```

Target Utilization:

```text
50%
```

Calculation:

```text
ceil(1 × 120/50)
= ceil(2.4)
= 3
```

Result:

```text
3 replicas
```

---

# Task 5: Generate Load

Create load generator:

```bash
kubectl run load-generator \
  --image=busybox:1.36 \
  --restart=Never \
  -- /bin/sh -c "while true; do wget -q -O- http://php-apache; done"
```

Verify:

```bash
kubectl get pods
```

Expected:

```text
load-generator   Running
```

---

# Watch HPA

Open another terminal:

```bash
kubectl get hpa php-apache --watch
```

Example:

```text
NAME         TARGETS   MINPODS MAXPODS REPLICAS
php-apache   45%/50%   1       10      1
php-apache   70%/50%   1       10      2
php-apache   90%/50%   1       10      3
php-apache   75%/50%   1       10      4
```

---

# Watch Deployment Scaling

```bash
kubectl get deployment php-apache -w
```

Example:

```text
READY   UP-TO-DATE   AVAILABLE
1/1
2/2
3/3
4/4
```

---

# Watch Pod Creation

```bash
kubectl get pods -w
```

Observe additional pods being created automatically.

---

## Verification

Maximum replicas reached:

```text
<your output here>
```

---

# Stop Load Generation

Delete load generator:

```bash
kubectl delete pod load-generator
```

Expected:

```text
pod "load-generator" deleted
```

---

# Scale Down Behavior

HPA does not immediately remove pods.

Default stabilization window:

```text
300 seconds (5 minutes)
```

This prevents rapid scaling fluctuations known as:

```text
Flapping
```

---

# Task 6: Declarative HPA (autoscaling/v2)

Delete existing HPA:

```bash
kubectl delete hpa php-apache
```

Create:

```bash
nano hpa.yaml
```

Manifest:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache

  minReplicas: 1
  maxReplicas: 10

  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50

  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15

    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
```

Apply:

```bash
kubectl apply -f hpa.yaml
```

Verify:

```bash
kubectl describe hpa php-apache
```

---

# What Does behavior Control?

The `behavior` section controls how aggressively HPA scales.

## scaleUp

Controls:

* How fast replicas are added
* Maximum scaling rate
* Stabilization period

Example:

```text
1 → 2 → 4 replicas
```

---

## scaleDown

Controls:

* How quickly replicas are removed
* Scale-down delay
* Stabilization window

Example:

```text
Wait 300 seconds before reducing replicas
```

---

# autoscaling/v1 vs autoscaling/v2

| Feature                    | autoscaling/v1 | autoscaling/v2 |
| -------------------------- | -------------- | -------------- |
| CPU Metrics                | Yes            | Yes            |
| Memory Metrics             | No             | Yes            |
| Custom Metrics             | No             | Yes            |
| External Metrics           | No             | Yes            |
| Scaling Policies           | No             | Yes            |
| Behavior Control           | No             | Yes            |
| Recommended for Production | Limited        | Yes            |

---

# Task 7: Cleanup

Delete HPA:

```bash
kubectl delete hpa php-apache
```

Delete Service:

```bash
kubectl delete svc php-apache
```

Delete Deployment:

```bash
kubectl delete deployment php-apache
```

Delete Load Generator:

```bash
kubectl delete pod load-generator --ignore-not-found
```

Leave Metrics Server installed for future exercises.

---

# Screenshots

Include the following screenshots:

## Screenshot 1

```bash
kubectl top nodes
```

---

## Screenshot 2

```bash
kubectl top pods -A
```

---

## Screenshot 3

```bash
kubectl get hpa
```

---

## Screenshot 4

```bash
kubectl describe hpa php-apache
```

---

## Screenshot 5

```bash
kubectl get deployment php-apache -w
```

showing scaling activity.

---

## Screenshot 6

```bash
kubectl get pods -w
```

showing new replicas being created.

---

# Key Learnings

* Metrics Server provides CPU and memory metrics for Kubernetes.
* HPA requires Metrics Server to make scaling decisions.
* Resource requests are mandatory for CPU-based autoscaling.
* HPA scales workloads horizontally by increasing or decreasing pod replicas.
* Metrics are collected approximately every 15 seconds.
* Scale-up is typically fast, while scale-down uses stabilization windows.
* `autoscaling/v2` provides advanced scaling policies and should be preferred for production workloads.
* HPA helps applications automatically adapt to changing traffic demands.
