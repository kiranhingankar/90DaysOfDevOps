# Day 52 – Kubernetes Namespaces and Deployments

## Objective

The goal of this task was to learn:

- Kubernetes Namespaces
- Deployments
- Self-healing capability
- Scaling applications
- Rolling updates and rollbacks

---

# What are Namespaces?

Namespaces in Kubernetes are logical partitions inside a cluster.

They help organize and isolate resources.

For example:

| Namespace | Purpose |
|---|---|
| dev | Development environment |
| staging | Testing/Staging environment |
| production | Production environment |

Namespaces allow multiple teams or applications to use the same cluster without conflicts.

---

# Default Kubernetes Namespaces

Kubernetes comes with built-in namespaces.

Command used:

```bash
kubectl get namespaces
```

Example output:

```bash
NAME              STATUS   AGE
default           Active   2d
kube-node-lease   Active   2d
kube-public       Active   2d
kube-system       Active   2d
```

## Explanation

| Namespace | Description |
|---|---|
| default | Default workspace for resources |
| kube-system | Internal Kubernetes components |
| kube-public | Public resources |
| kube-node-lease | Node heartbeat tracking |

---

# Checking kube-system Pods

Command used:

```bash
kubectl get pods -n kube-system
```

This namespace contains critical Kubernetes components like:

- kube-apiserver
- etcd
- kube-scheduler
- coredns

These components keep the cluster running.

---

# Creating Custom Namespaces

## Commands Used

```bash
kubectl create namespace dev
kubectl create namespace staging
```

Verify namespaces:

```bash
kubectl get namespaces
```

---

# Creating Namespace Using YAML

## namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
```

Apply the manifest:

```bash
kubectl apply -f namespace.yaml
```

---

# Running Pods in Different Namespaces

## Commands Used

```bash
kubectl run nginx-dev --image=nginx:latest -n dev

kubectl run nginx-staging --image=nginx:latest -n staging
```

View all pods:

```bash
kubectl get pods -A
```

Example output:

```bash
NAMESPACE     NAME              READY   STATUS
dev           nginx-dev         1/1     Running
staging       nginx-staging     1/1     Running
```

---

# Difference Between kubectl get pods and kubectl get pods -A

## kubectl get pods

Shows pods only from the default namespace.

## kubectl get pods -A

Shows pods from all namespaces.

---

# Kubernetes Deployment

A Deployment manages Pods automatically.

Features of Deployments:

- Maintains desired replica count
- Automatically recreates failed pods
- Supports scaling
- Supports rolling updates
- Supports rollback

---

# nginx-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx

spec:
  replicas: 3

  selector:
    matchLabels:
      app: nginx

  template:
    metadata:
      labels:
        app: nginx

    spec:
      containers:
      - name: nginx
        image: nginx:1.24

        ports:
        - containerPort: 80
```

---

# Deployment YAML Explanation

## apiVersion

```yaml
apiVersion: apps/v1
```

Defines the API group for Deployments.

---

## kind

```yaml
kind: Deployment
```

Specifies the resource type.

---

## metadata

```yaml
metadata:
  name: nginx-deployment
```

Defines the Deployment name.

---

## namespace

```yaml
namespace: dev
```

Deploys resources inside the dev namespace.

---

## replicas

```yaml
replicas: 3
```

Kubernetes maintains 3 identical pods.

---

## selector.matchLabels

```yaml
selector:
  matchLabels:
    app: nginx
```

Deployment manages pods having label:

```yaml
app: nginx
```

---

## template

Defines the Pod blueprint.

---

## containers

Defines container configuration.

```yaml
containers:
- name: nginx
  image: nginx:1.24
```

---

# Applying the Deployment

Command used:

```bash
kubectl apply -f nginx-deployment.yaml
```

Verify Deployment:

```bash
kubectl get deployments -n dev
```

Example output:

```bash
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           1m
```

---

# Meaning of Deployment Columns

| Column | Meaning |
|---|---|
| READY | Number of running replicas |
| UP-TO-DATE | Pods updated with latest configuration |
| AVAILABLE | Healthy pods available for traffic |

---

# Viewing Deployment Pods

Command used:

```bash
kubectl get pods -n dev
```

Example output:

```bash
NAME                                READY   STATUS
nginx-deployment-xxxxx-yyyyy        1/1     Running
nginx-deployment-xxxxx-zzzzz        1/1     Running
nginx-deployment-xxxxx-aaaaa        1/1     Running
```

---

# Self-Healing Demonstration

One major advantage of Deployments is self-healing.

## Step 1 — List Pods

```bash
kubectl get pods -n dev
```

## Step 2 — Delete a Pod

```bash
kubectl delete pod <pod-name> -n dev
```

## Step 3 — Check Again

```bash
kubectl get pods -n dev
```

Kubernetes automatically creates a replacement pod.

---

# Difference Between Standalone Pod and Deployment Pod

| Standalone Pod | Deployment Pod |
|---|---|
| Deleted permanently | Automatically recreated |
| No management | Managed by Deployment |
| Manual recovery | Self-healing |

---

# Scaling Deployments

Scaling changes the number of pod replicas.

---

# Imperative Scaling

## Scale Up

```bash
kubectl scale deployment nginx-deployment --replicas=5 -n dev
```

## Scale Down

```bash
kubectl scale deployment nginx-deployment --replicas=2 -n dev
```

Kubernetes automatically creates or deletes pods.

---

# Declarative Scaling

Edit YAML file:

```yaml
replicas: 4
```

Apply again:

```bash
kubectl apply -f nginx-deployment.yaml
```

---

# What Happens During Scale Down?

When scaling down:

- Extra pods are terminated gracefully
- Kubernetes keeps only desired replicas running

---

# Rolling Updates

Rolling updates allow updating applications without downtime.

---

# Updating Container Image

Command used:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
```

---

# Checking Rollout Status

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Example output:

```bash
deployment "nginx-deployment" successfully rolled out
```

---

# How Rolling Update Works

Kubernetes performs updates gradually:

1. Creates new pod
2. Waits until healthy
3. Deletes old pod
4. Repeats process

This ensures zero downtime.

---

# Rollout History

Command used:

```bash
kubectl rollout history deployment/nginx-deployment -n dev
```

Example output:

```bash
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

---

# Rollback

Rollback restores previous Deployment version.

## Command Used

```bash
kubectl rollout undo deployment/nginx-deployment -n dev
```

Check rollout status:

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Verify image version:

```bash
kubectl describe deployment nginx-deployment -n dev
```

Example:

```bash
Image: nginx:1.24
```

Rollback successfully restored previous version.

---

# ReplicaSets

Deployments create ReplicaSets internally.

Command used:

```bash
kubectl get replicasets -n dev
```

ReplicaSets maintain desired pod replicas.

---

# Cleanup

## Delete Deployment

```bash
kubectl delete deployment nginx-deployment -n dev
```

## Delete Pods

```bash
kubectl delete pod nginx-dev -n dev

kubectl delete pod nginx-staging -n staging
```

## Delete Namespaces

```bash
kubectl delete namespace dev staging production
```

---

# Verification After Cleanup

Commands used:

```bash
kubectl get namespaces

kubectl get pods -A
```

All custom resources should be removed.

---

# Screenshots

Include screenshots for:

## Deployments

```bash
kubectl get deployments -n dev
```

## Pods Across All Namespaces

```bash
kubectl get pods -A
```

Store screenshots inside:

```text
2026/day-52/screenshots/
```

---

# Key Learnings

| Concept | Description |
|---|---|
| Namespace | Logical isolation inside cluster |
| Deployment | Manages Pods automatically |
| ReplicaSet | Maintains replica count |
| Self-healing | Recreates failed pods |
| Scaling | Increase/decrease replicas |
| Rolling Update | Zero-downtime update |
| Rollback | Restore previous version |

---

# Conclusion

In this task, I learned how Kubernetes Deployments provide high availability and self-healing capabilities compared to standalone Pods.

I also learned:

- Namespace isolation
- Scaling applications
- Rolling updates
- Rollbacks
- ReplicaSets

Deployments are the standard way to run applications in Kubernetes production environments.

---