# Day 56 – Kubernetes StatefulSets

## Introduction

Deployments work great for stateless applications such as web servers and APIs. However, databases and distributed systems require stable identities, persistent storage, and predictable networking.

Kubernetes provides **StatefulSets** to manage stateful applications like:

* MySQL
* PostgreSQL
* MongoDB
* Kafka
* Cassandra
* Redis Clusters

StatefulSets provide:

* Stable pod names
* Ordered pod startup and shutdown
* Stable DNS names
* Dedicated persistent storage for each pod

---

# Deployment vs StatefulSet

| Feature        | Deployment       | StatefulSet             |
| -------------- | ---------------- | ----------------------- |
| Pod names      | Random           | Stable and ordered      |
| Startup order  | Parallel         | Ordered                 |
| Shutdown order | Random           | Reverse ordered         |
| Storage        | Shared/Ephemeral | Dedicated PVC per pod   |
| Stable DNS     | No               | Yes                     |
| Best for       | Stateless apps   | Stateful apps/databases |

---

# Why Databases Need StatefulSets

Databases require:

* Stable network identities
* Persistent storage
* Predictable hostnames
* Ordered startup and shutdown

Example database cluster:

```text
mysql-0
mysql-1
mysql-2
```

If pod names change randomly after restart, cluster replication and communication may fail.

---

# Task 1 – Understanding the Problem

## Create a Deployment

Create `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3

  selector:
    matchLabels:
      app: nginx-demo

  template:
    metadata:
      labels:
        app: nginx-demo

    spec:
      containers:
      - name: nginx
        image: nginx
```

Apply the deployment:

```bash
kubectl apply -f deployment.yaml
```

Check the pods:

```bash
kubectl get pods
```

Example output:

```text
nginx-deployment-7b9c6d9f7f-abc12
nginx-deployment-7b9c6d9f7f-def34
nginx-deployment-7b9c6d9f7f-ghi56
```

Notice the random pod names.

Delete one pod:

```bash
kubectl delete pod nginx-deployment-7b9c6d9f7f-abc12
```

Check pods again:

```bash
kubectl get pods
```

A new pod appears with a completely different name.

### Why is this a problem?

Databases and clustered applications rely on fixed identities and stable networking. Random pod names can break replication and node communication.

Delete the deployment before continuing:

```bash
kubectl delete deployment nginx-deployment
```

---

# Task 2 – Create a Headless Service

## What is a Headless Service?

A normal Kubernetes Service load-balances traffic to pods using a single ClusterIP.

A Headless Service:

* Does not provide load balancing
* Creates DNS records for individual pods
* Is required for StatefulSets

---

## Create `headless-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-headless

spec:
  clusterIP: None

  selector:
    app: nginx-stateful

  ports:
  - port: 80
    name: web
```

Apply the service:

```bash
kubectl apply -f headless-service.yaml
```

Verify:

```bash
kubectl get svc
```

Expected output:

```text
NAME              TYPE        CLUSTER-IP   PORT(S)
nginx-headless    ClusterIP   None         80/TCP
```

### Verification

The `CLUSTER-IP` column should show:

```text
None
```

---

# Task 3 – Create a StatefulSet

## Create `statefulset.yaml`

```yaml
apiVersion: apps/v1
kind: StatefulSet

metadata:
  name: web

spec:
  serviceName: nginx-headless
  replicas: 3

  selector:
    matchLabels:
      app: nginx-stateful

  template:
    metadata:
      labels:
        app: nginx-stateful

    spec:
      containers:
      - name: nginx
        image: nginx

        ports:
        - containerPort: 80
          name: web

        volumeMounts:
        - name: web-data
          mountPath: /usr/share/nginx/html

  volumeClaimTemplates:
  - metadata:
      name: web-data

    spec:
      accessModes:
      - ReadWriteOnce

      resources:
        requests:
          storage: 100Mi
```

Apply the StatefulSet:

```bash
kubectl apply -f statefulset.yaml
```

Watch pod creation:

```bash
kubectl get pods -l app=nginx-stateful -w
```

Observe ordered startup:

```text
web-0
web-1
web-2
```

Pods are created sequentially.

---

# Verify Pods

```bash
kubectl get pods
```

Expected:

```text
web-0
web-1
web-2
```

---

# Verify PVCs

```bash
kubectl get pvc
```

Expected:

```text
web-data-web-0
web-data-web-1
web-data-web-2
```

PVC naming pattern:

```text
<template-name>-<pod-name>
```

Example:

```text
web-data-web-0
```

---

# Task 4 – Stable Network Identity

Each StatefulSet pod gets a stable DNS name.

DNS format:

```text
<pod-name>.<service-name>.<namespace>.svc.cluster.local
```

Example:

```text
web-0.nginx-headless.default.svc.cluster.local
```

---

# Test DNS Resolution

Run a temporary BusyBox pod:

```bash
kubectl run busybox --image=busybox:1.28 --rm -it -- sh
```

Inside the BusyBox shell:

```bash
nslookup web-0.nginx-headless.default.svc.cluster.local
```

Repeat for:

```bash
nslookup web-1.nginx-headless.default.svc.cluster.local
nslookup web-2.nginx-headless.default.svc.cluster.local
```

Check pod IPs:

```bash
kubectl get pods -o wide
```

### Verification

The IP returned by `nslookup` should match the pod IP.

---

# Task 5 – Persistent Storage Test

## Write Data to a Pod

```bash
kubectl exec web-0 -- sh -c "echo 'Data from web-0' > /usr/share/nginx/html/index.html"
```

Verify:

```bash
kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
```

Expected:

```text
Data from web-0
```

---

# Delete the Pod

```bash
kubectl delete pod web-0
```

Wait for recreation:

```bash
kubectl get pods -w
```

A new `web-0` pod appears.

---

# Verify Data Persistence

```bash
kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
```

Expected output:

```text
Data from web-0
```

### Why did the data survive?

The recreated pod reattached to the same Persistent Volume Claim:

```text
web-data-web-0
```

---

# Task 6 – Ordered Scaling

## Scale Up

```bash
kubectl scale statefulset web --replicas=5
```

Watch:

```bash
kubectl get pods -w
```

Pods are created in order:

```text
web-3
web-4
```

---

# Check PVCs

```bash
kubectl get pvc
```

Expected:

```text
web-data-web-0
web-data-web-1
web-data-web-2
web-data-web-3
web-data-web-4
```

---

# Scale Down

```bash
kubectl scale statefulset web --replicas=3
```

Pods terminate in reverse order:

```text
web-4
web-3
```

---

# Verify PVCs After Scaling Down

```bash
kubectl get pvc
```

All five PVCs still exist.

### Why?

Kubernetes preserves storage to prevent accidental data loss.

---

# Task 7 – Cleanup

Delete StatefulSet:

```bash
kubectl delete statefulset web
```

Delete Headless Service:

```bash
kubectl delete service nginx-headless
```

Check PVCs:

```bash
kubectl get pvc
```

PVCs still exist.

Delete them manually:

```bash
kubectl delete pvc --all
```

---

# Important Concepts

## StatefulSet Pod Naming

Pattern:

```text
<statefulset-name>-<ordinal>
```

Examples:

```text
web-0
web-1
web-2
```

---

# StatefulSet DNS

Pattern:

```text
<pod-name>.<service-name>.<namespace>.svc.cluster.local
```

Example:

```text
web-0.nginx-headless.default.svc.cluster.local
```

---

# VolumeClaimTemplates

`volumeClaimTemplates` automatically creates one PVC per pod.

Example:

| Pod   | PVC            |
| ----- | -------------- |
| web-0 | web-data-web-0 |
| web-1 | web-data-web-1 |
| web-2 | web-data-web-2 |

Each pod gets independent persistent storage.

---

# Ordered Behavior

## Ordered Startup

Pods start sequentially:

```text
web-0 → web-1 → web-2
```

## Ordered Shutdown

Pods terminate in reverse order:

```text
web-2 → web-1 → web-0
```

---

# Useful Commands

```bash
kubectl get sts

kubectl get pods

kubectl get pvc

kubectl get svc

kubectl describe sts web

kubectl scale statefulset web --replicas=5

kubectl delete pod web-0

kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
```

---

# Screenshots to Include

Add screenshots of:

* `kubectl get pods`
* `kubectl get pvc`
* `kubectl get svc`
* `nslookup` results
* Pod recreation test
* Ordered scaling behavior

---

# Real-World Use Cases

StatefulSets are commonly used for:

* MySQL
* PostgreSQL
* MongoDB
* Kafka
* Cassandra
* Elasticsearch
* Redis Clusters

Deployments are better suited for:

* Frontend applications
* APIs
* Stateless microservices
* Web servers

---

# Conclusion

StatefulSets solve three major problems for stateful applications:

1. Stable identity
2. Stable storage
3. Stable networking

Unlike Deployments, StatefulSets ensure that pods retain their identity and storage even after recreation, making them ideal for databases and distributed systems.

---
