# Day 57 – Resource Requests, Limits, and Probes

## Objective

Today I learned how Kubernetes manages resources using requests and limits, how Out Of Memory (OOM) situations are handled, how the scheduler behaves when resources are insufficient, and how liveness, readiness, and startup probes help Kubernetes maintain application health and availability.

---

# Resource Requests and Limits

## What are Resource Requests?

Resource requests define the minimum amount of CPU and memory required by a Pod.

The Kubernetes scheduler uses requests to determine which node can run the Pod.

Example:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
```

### Explanation

* `100m` CPU = 0.1 CPU Core
* `128Mi` Memory = 128 Mebibytes

Requests guarantee that the specified resources are reserved for the Pod.

---

## What are Resource Limits?

Resource limits define the maximum amount of CPU and memory a container can consume.

Example:

```yaml
resources:
  limits:
    cpu: "250m"
    memory: "256Mi"
```

### Explanation

* CPU can use up to 0.25 CPU Core
* Memory can use up to 256 MiB

Limits are enforced by the kubelet.

---

## Requests vs Limits

| Requests                     | Limits                    |
| ---------------------------- | ------------------------- |
| Minimum guaranteed resources | Maximum allowed resources |
| Used by scheduler            | Enforced at runtime       |
| Determines placement         | Prevents resource abuse   |

---

# Task 1: Resource Requests and Limits

## Pod Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "250m"
        memory: "256Mi"
```

## Apply

```bash
kubectl apply -f resource-demo.yaml
```

## Verify

```bash
kubectl describe pod resource-demo
```

Expected:

```text
Requests:
  cpu: 100m
  memory: 128Mi

Limits:
  cpu: 250m
  memory: 256Mi
```

---

# QoS Classes

Kubernetes assigns Quality of Service (QoS) classes based on requests and limits.

| QoS Class  | Condition             |
| ---------- | --------------------- |
| Guaranteed | Requests = Limits     |
| Burstable  | Requests < Limits     |
| BestEffort | No requests or limits |

### Observed Result

```text
QoS Class: Burstable
```

Because requests and limits are different.

---

# Task 2: OOMKilled Demonstration

## Objective

Observe what happens when a container exceeds its memory limit.

---

## Pod Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: oom-demo
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args:
      - "--vm"
      - "1"
      - "--vm-bytes"
      - "200M"
      - "--vm-hang"
      - "1"
    resources:
      limits:
        memory: "100Mi"
```

---

## Apply

```bash
kubectl apply -f oom-demo.yaml
```

---

## Verify

```bash
kubectl describe pod oom-demo
```

Expected:

```text
Reason: OOMKilled
Exit Code: 137
```

---

## Key Learning

### CPU Limit Exceeded

CPU is throttled.

### Memory Limit Exceeded

Container is terminated immediately.

### Exit Code 137

```text
137 = 128 + SIGKILL(9)
```

This indicates the Linux kernel killed the process because it exceeded its memory limit.

---

# Task 3: Pending Pod Due to Insufficient Resources

## Objective

Observe scheduler behavior when a Pod requests more resources than available.

---

## Pod Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: huge-request
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      requests:
        cpu: "100"
        memory: "128Gi"
```

---

## Apply

```bash
kubectl apply -f huge-request.yaml
```

---

## Verify

```bash
kubectl get pod
```

Expected:

```text
STATUS: Pending
```

---

## Describe Pod

```bash
kubectl describe pod huge-request
```

Expected Event:

```text
0/X nodes are available:
Insufficient cpu.
Insufficient memory.
```

---

## Key Learning

The scheduler cannot place a Pod on any node if the requested resources are unavailable.

---

# Task 4: Liveness Probe

## What is a Liveness Probe?

A liveness probe checks whether an application is still alive.

If the probe fails repeatedly, Kubernetes restarts the container.

---

## Pod Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: liveness-demo
spec:
  containers:
  - name: busybox
    image: busybox
    args:
      - /bin/sh
      - -c
      - touch /tmp/healthy;
        sleep 30;
        rm -f /tmp/healthy;
        sleep 600

    livenessProbe:
      exec:
        command:
          - cat
          - /tmp/healthy
      periodSeconds: 5
      failureThreshold: 3
```

---

## Apply

```bash
kubectl apply -f liveness-demo.yaml
```

---

## Verify

```bash
kubectl get pod -w
```

Expected:

```text
RESTARTS: 1+
```

---

## Key Learning

Liveness failures trigger container restarts.

---

# Task 5: Readiness Probe

## What is a Readiness Probe?

A readiness probe determines whether a Pod is ready to receive traffic.

When readiness fails:

* Pod is removed from Service endpoints
* Container is NOT restarted

---

## Pod Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: readiness-demo
  labels:
    app: readiness-demo
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      httpGet:
        path: /
        port: 80
      periodSeconds: 5
```

---

## Create Service

```bash
kubectl expose pod readiness-demo --port=80 --name=readiness-svc
```

---

## Verify Endpoints

```bash
kubectl get endpoints readiness-svc
```

Expected:

```text
10.x.x.x:80
```

---

## Break Readiness

```bash
kubectl exec readiness-demo -- rm /usr/share/nginx/html/index.html
```

---

## Verify

```bash
kubectl get pod
```

Expected:

```text
READY 0/1
```

Check endpoints:

```bash
kubectl get endpoints readiness-svc
```

Expected:

```text
<none>
```

---

## Key Learning

Readiness failure removes traffic routing but does not restart the application.

---

# Task 6: Startup Probe

## What is a Startup Probe?

A startup probe allows slow-starting applications to initialize before liveness and readiness checks begin.

While the startup probe is running:

* Liveness probe is disabled
* Readiness probe is disabled

---

## Pod Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: startup-demo
spec:
  containers:
  - name: busybox
    image: busybox
    command:
      - sh
      - -c
      - |
        sleep 20
        touch /tmp/started
        sleep 600

    startupProbe:
      exec:
        command:
        - cat
        - /tmp/started
      periodSeconds: 5
      failureThreshold: 12

    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/started
      periodSeconds: 5
```

---

## Verification

```bash
kubectl get pod startup-demo -w
```

Expected:

```text
READY 1/1
RESTARTS 0
```

---

## What Happens If failureThreshold = 2?

Startup budget:

```text
5 × 2 = 10 seconds
```

Application startup time:

```text
20 seconds
```

Result:

```text
Startup probe fails
Container restarted
Restart loop begins
```

Observed Events:

```text
Startup probe failed
Container failed startup probe, will be restarted
```

Observed:

```text
RESTARTS: 3
READY: 0/1
```

---

## Key Learning

Startup probes prevent slow applications from being killed before they finish initialization.

---

# Probe Comparison

| Probe Type | Purpose                            | Failure Action                |
| ---------- | ---------------------------------- | ----------------------------- |
| Liveness   | Is application alive?              | Restart container             |
| Readiness  | Can application receive traffic?   | Remove from Service endpoints |
| Startup    | Has application finished starting? | Restart container             |

---

# Screenshots to Include

Capture screenshots of:

1. Resource Requests and Limits

   ```bash
   kubectl describe pod resource-demo
   ```

2. OOMKilled Container

   ```bash
   kubectl describe pod oom-demo
   ```

3. Pending Pod Events

   ```bash
   kubectl describe pod huge-request
   ```

4. Liveness Probe Restart

   ```bash
   kubectl get pod -w
   ```

5. Readiness Probe Failure

   ```bash
   kubectl get endpoints readiness-svc
   ```

6. Startup Probe Events

   ```bash
   kubectl describe pod startup-demo
   ```

---

# Interview Questions

## What is the difference between Requests and Limits?

Requests are used for scheduling and represent guaranteed resources. Limits define the maximum resources a container can consume.

---

## What happens when CPU limits are exceeded?

CPU is throttled.

---

## What happens when Memory limits are exceeded?

The container is terminated and marked as OOMKilled.

---

## What is the exit code for OOMKilled?

```text
137
```

---

## What is the difference between Liveness and Readiness?

Liveness determines whether a container should be restarted.

Readiness determines whether a container should receive traffic.

---

## What is the purpose of a Startup Probe?

It allows slow-starting applications enough time to initialize before liveness and readiness checks begin.

---

# Cleanup

Delete all created resources:

```bash
kubectl delete pod resource-demo
kubectl delete pod oom-demo
kubectl delete pod huge-request
kubectl delete pod liveness-demo
kubectl delete pod readiness-demo
kubectl delete pod startup-demo

kubectl delete svc readiness-svc
```

---

# Key Takeaways

* Requests reserve resources for scheduling.
* Limits prevent excessive resource consumption.
* CPU overuse results in throttling.
* Memory overuse results in OOMKilled.
* Liveness probes restart unhealthy containers.
* Readiness probes control traffic flow.
* Startup probes protect slow-starting applications.
* Kubernetes automatically recovers failed workloads through health checks.

---

## Conclusion

Day 57 focused on Kubernetes resource management and health monitoring. I learned how requests and limits influence scheduling and runtime behavior, how Kubernetes handles OOM situations, and how liveness, readiness, and startup probes enable self-healing and resilient applications.
