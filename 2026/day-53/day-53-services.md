# Day 53 – Kubernetes Services

## Objective

Today I learned about Kubernetes Services and how they provide stable networking and load balancing for Pods inside a Kubernetes cluster.

---

# Why Kubernetes Services Are Needed

Pods in Kubernetes are temporary.

When a Pod:
- crashes
- restarts
- gets recreated

its IP address changes.

Example:

```text
Old Pod IP -> 10.244.0.5
New Pod IP -> 10.244.0.8
```

Applications cannot reliably communicate using changing Pod IPs.

Kubernetes Services solve this problem by providing:
- Stable IP addresses
- Stable DNS names
- Load balancing across Pods

---

# Kubernetes Service Architecture

```text
Client
   |
   v
Kubernetes Service
   |
   +----> Pod 1
   +----> Pod 2
   +----> Pod 3
```

The Service automatically distributes traffic across all healthy Pods.

---

# Task 1 – Create Deployment

## File: `app-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: web-app
  labels:
    app: web-app

spec:
  replicas: 3

  selector:
    matchLabels:
      app: web-app

  template:
    metadata:
      labels:
        app: web-app

    spec:
      containers:
      - name: nginx
        image: nginx:1.25

        ports:
        - containerPort: 80
```

---

# Apply Deployment

```bash
kubectl apply -f app-deployment.yaml
```

---

# Verify Pods

```bash
kubectl get pods -o wide
```

Example Output:

```text
NAME                        READY   STATUS    IP
web-app-xxxxx               1/1     Running   10.244.0.7
web-app-xxxxx               1/1     Running   10.244.0.8
web-app-xxxxx               1/1     Running   10.244.0.9
```

---

# Task 2 – Create ClusterIP Service

ClusterIP allows internal communication inside the cluster.

---

## File: `clusterip-service.yaml`

```yaml
apiVersion: v1
kind: Service

metadata:
  name: web-app-clusterip

spec:
  type: ClusterIP

  selector:
    app: web-app

  ports:
  - port: 80
    targetPort: 80
```

---

# Apply Service

```bash
kubectl apply -f clusterip-service.yaml
```

---

# Verify Service

```bash
kubectl get svc
```

Example Output:

```text
NAME                  TYPE        CLUSTER-IP
web-app-clusterip     ClusterIP   10.96.64.228
```

---

# Verify Endpoints

```bash
kubectl get endpoints
```

Example:

```text
web-app-clusterip   10.244.0.7:80,10.244.0.8:80,10.244.0.9:80
```

Endpoints show which Pods the Service routes traffic to.

---

# Test ClusterIP Service

Run temporary BusyBox Pod:

```bash
kubectl run test-client \
--image=busybox \
--rm -it \
--restart=Never -- sh
```

Inside BusyBox:

```bash
wget -qO- http://web-app-clusterip
```

Expected Output:

```html
Welcome to nginx!
```

Exit BusyBox:

```bash
exit
```

---

# Task 3 – Kubernetes DNS

Kubernetes automatically creates DNS entries for Services.

DNS format:

```text
<service-name>.<namespace>.svc.cluster.local
```

Example:

```text
web-app-clusterip.default.svc.cluster.local
```

---

# Test DNS

Launch BusyBox:

```bash
kubectl run dns-test \
--image=busybox \
--rm -it \
--restart=Never -- sh
```

Inside BusyBox:

## Test Short DNS Name

```bash
wget -qO- http://web-app-clusterip
```

## Test Full DNS Name

```bash
wget -qO- http://web-app-clusterip.default.svc.cluster.local
```

## Verify DNS Resolution

```bash
nslookup web-app-clusterip
```

Expected Output:

```text
Address: 10.96.x.x
```

Exit BusyBox:

```bash
exit
```

---

# Task 4 – Create NodePort Service

NodePort exposes the application outside the cluster.

Traffic Flow:

```text
Browser
   |
NodeIP:30080
   |
NodePort Service
   |
Pods
```

---

## File: `nodeport-service.yaml`

```yaml
apiVersion: v1
kind: Service

metadata:
  name: web-app-nodeport

spec:
  type: NodePort

  selector:
    app: web-app

  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

---

# Apply NodePort Service

```bash
kubectl apply -f nodeport-service.yaml
```

---

# Verify NodePort Service

```bash
kubectl get svc
```

Example Output:

```text
NAME                 TYPE       PORT(S)
web-app-nodeport     NodePort   80:30080/TCP
```

---

# Verify Endpoints

```bash
kubectl get endpoints
```

Example:

```text
web-app-nodeport   10.244.0.7:80,10.244.0.8:80,10.244.0.9:80
```

---

# Access NodePort Service

Since I used KIND on Windows, direct Node IP access did not work reliably.

I used port forwarding instead.

Run:

```bash
kubectl port-forward svc/web-app-nodeport 8080:80
```

Expected Output:

```text
Forwarding from 127.0.0.1:8080 -> 80
```

Open browser:

```text
http://localhost:8080
```

Expected Output:

```html
Welcome to nginx!
```

---

# Task 5 – Create LoadBalancer Service

LoadBalancer is mainly used in cloud environments like:
- AWS
- Azure
- GCP

---

## File: `loadbalancer-service.yaml`

```yaml
apiVersion: v1
kind: Service

metadata:
  name: web-app-loadbalancer

spec:
  type: LoadBalancer

  selector:
    app: web-app

  ports:
  - port: 80
    targetPort: 80
```

---

# Apply LoadBalancer Service

```bash
kubectl apply -f loadbalancer-service.yaml
```

---

# Verify LoadBalancer Service

```bash
kubectl get svc
```

Example Output:

```text
NAME                     TYPE           EXTERNAL-IP
web-app-loadbalancer     LoadBalancer   <pending>
```

---

# Why EXTERNAL-IP Shows `<pending>`

I used a local KIND cluster.

Local clusters do not have:
- AWS ELB
- Azure Load Balancer
- GCP Load Balancer

Therefore Kubernetes cannot provision a real external load balancer.

This is expected behavior.

---

# Describe LoadBalancer Service

```bash
kubectl describe svc web-app-loadbalancer
```

Example Important Output:

```text
Type:       LoadBalancer
IP:         10.96.64.228
NodePort:   31607/TCP

Endpoints:
10.244.0.7:80
10.244.0.8:80
10.244.0.9:80
```

---

# Important Concepts Learned

## Selector

```yaml
selector:
  app: web-app
```

The Service forwards traffic to Pods with matching labels.

---

## Endpoints

Endpoints are actual Pod IP addresses behind the Service.

View endpoints:

```bash
kubectl get endpoints
```

---

## ClusterIP

- Internal cluster communication
- Default Service type
- Accessible only inside cluster

---

## NodePort

- External access through Node IP and port
- Mainly used for development/testing

---

## LoadBalancer

- Used in cloud environments
- Creates:
  - ClusterIP
  - NodePort
  - External Load Balancer

Relationship:

```text
LoadBalancer
   └── NodePort
          └── ClusterIP
```

---

# Service Type Comparison

| Type | Accessible From | Use Case |
|---|---|---|
| ClusterIP | Inside cluster only | Internal communication |
| NodePort | External via NodeIP | Development/testing |
| LoadBalancer | External cloud access | Production |

---

# Useful Commands

## View Pods

```bash
kubectl get pods -o wide
```

---

## View Services

```bash
kubectl get svc
```

---

## View Endpoints

```bash
kubectl get endpoints
```

---

## Describe Service

```bash
kubectl describe svc web-app-loadbalancer
```

---

## View Labels

```bash
kubectl get pods --show-labels
```

---

# Common Errors and Fixes

| Error | Meaning |
|---|---|
| bad address | DNS resolution failed |
| connection refused | Application not listening |
| timeout | Network unreachable |
| endpoints `<none>` | Service found no Pods |

---

# Cleanup

Delete Deployment:

```bash
kubectl delete -f app-deployment.yaml
```

Delete Services:

```bash
kubectl delete -f clusterip-service.yaml

kubectl delete -f nodeport-service.yaml

kubectl delete -f loadbalancer-service.yaml
```

Verify Cleanup:

```bash
kubectl get pods
```

```bash
kubectl get svc
```

Only default Kubernetes service should remain.

---

# Final Summary

Today I learned:
- Why Kubernetes Services are needed
- How Services provide stable networking
- ClusterIP Service
- NodePort Service
- LoadBalancer Service
- Kubernetes DNS
- Service discovery
- Endpoints
- Load balancing across Pods
- Port forwarding with KIND on Windows

This helped me understand the core Kubernetes networking concepts.