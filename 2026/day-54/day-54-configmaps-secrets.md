# Day 54 – Kubernetes ConfigMaps and Secrets

## Introduction

Applications require configuration values such as:
- Database URLs
- API keys
- Feature flags
- Port numbers
- Environment names

Hardcoding these values inside container images is not a good practice because every configuration change requires rebuilding and redeploying the image.

Kubernetes solves this problem using:
- **ConfigMaps** → for non-sensitive configuration
- **Secrets** → for sensitive data

---

# What are ConfigMaps?

A ConfigMap is used to store:
- Application configuration
- Environment variables
- Config files
- Command-line arguments

ConfigMaps store data as plain text.

## Examples
- APP_ENV=production
- APP_PORT=8080
- nginx.conf
- application.properties

---

# What are Secrets?

Secrets are used to store sensitive information such as:
- Passwords
- API keys
- Tokens
- Database credentials

Secrets are stored as base64 encoded values inside Kubernetes.

> Base64 is encoding, NOT encryption.

Anyone with cluster access can decode them.

---

# Prerequisites

Before starting:
- Kubernetes cluster should be running
- kubectl should be configured
- You should be able to create Pods

Check cluster status:

```bash
kubectl get nodes
```

---

# Task 1 – Create a ConfigMap from Literals

## Step 1 – Create ConfigMap

```bash
kubectl create configmap app-config \
  --from-literal=APP_ENV=production \
  --from-literal=APP_DEBUG=false \
  --from-literal=APP_PORT=8080
```

---

## Step 2 – Verify ConfigMap

### Describe ConfigMap

```bash
kubectl describe configmap app-config
```

Expected Output:

```text
Name:         app-config
Data
====
APP_ENV:
----
production

APP_DEBUG:
----
false

APP_PORT:
----
8080
```

---

### View YAML

```bash
kubectl get configmap app-config -o yaml
```

Expected Output:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: production
  APP_DEBUG: "false"
  APP_PORT: "8080"
```

---

## Observation

ConfigMap values are:
- Plain text
- Not encrypted
- Human readable

Use ConfigMaps only for non-sensitive configuration.

---

# Task 2 – Create a ConfigMap from a File

## Step 1 – Create Nginx Config File

Create file:

```bash
nano default.conf
```

Add:

```nginx
server {
    listen 80;

    location / {
        return 200 'Welcome to Nginx';
    }

    location /health {
        return 200 'healthy';
    }
}
```

Save the file.

---

## Step 2 – Create ConfigMap from File

```bash
kubectl create configmap nginx-config \
  --from-file=default.conf=default.conf
```

Explanation:

```text
KEY NAME      = default.conf
FILE CONTENTS = stored inside ConfigMap
```

---

## Step 3 – Verify ConfigMap

```bash
kubectl get configmap nginx-config -o yaml
```

Expected Output:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  default.conf: |
    server {
        listen 80;

        location / {
            return 200 'Welcome to Nginx';
        }

        location /health {
            return 200 'healthy';
        }
    }
```

---

# Task 3 – Use ConfigMaps in Pods

ConfigMaps can be used in two ways:
1. Environment Variables
2. Volume Mounts

---

# Part A – Inject ConfigMap as Environment Variables

## Step 1 – Create Pod Manifest

Create file:

```bash
nano configmap-env-pod.yaml
```

Add:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-env-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
      - env && sleep 3600

    envFrom:
    - configMapRef:
        name: app-config
```

---

## Step 2 – Apply Manifest

```bash
kubectl apply -f configmap-env-pod.yaml
```

---

## Step 3 – Verify Environment Variables

```bash
kubectl logs configmap-env-pod
```

Expected Output:

```text
APP_ENV=production
APP_DEBUG=false
APP_PORT=8080
```

---

# Part B – Mount ConfigMap as Volume

## Step 1 – Create Pod Manifest

Create file:

```bash
nano nginx-config-pod.yaml
```

Add:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-config-pod
spec:
  containers:
  - name: nginx
    image: nginx

    volumeMounts:
    - name: nginx-config-volume
      mountPath: /etc/nginx/conf.d

  volumes:
  - name: nginx-config-volume
    configMap:
      name: nginx-config
```

---

## Step 2 – Apply Manifest

```bash
kubectl apply -f nginx-config-pod.yaml
```

---

## Step 3 – Verify Pod

```bash
kubectl get pods
```

Wait until:

```text
STATUS = Running
```

---

## Step 4 – Test Health Endpoint

```bash
kubectl exec nginx-config-pod -- curl -s http://localhost/health
```

Expected Output:

```text
healthy
```

---

# Difference Between Environment Variables and Volume Mounts

| Feature | Environment Variables | Volume Mounts |
|---|---|---|
| Best For | Simple key-values | Full config files |
| Access Method | `$VAR_NAME` | Filesystem |
| Auto Updates | No | Yes |
| Example | APP_PORT | nginx.conf |

---

# Task 4 – Create a Secret

## Step 1 – Create Secret

```bash
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASSWORD='s3cureP@ssw0rd'
```

---

## Step 2 – View Secret

```bash
kubectl get secret db-credentials -o yaml
```

Expected Output:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
data:
  DB_PASSWORD: czNjdXJlUEBzc3cwcmQ=
  DB_USER: YWRtaW4=
```

---

# Why Base64 is NOT Encryption

Base64:
- Only converts data into ASCII format
- Does NOT secure data
- Can easily be decoded

Example:

```bash
echo 'czNjdXJlUEBzc3cwcmQ=' | base64 --decode
```

Output:

```text
s3cureP@ssw0rd
```

---

# Why Kubernetes Secrets are Still Useful

Secrets provide:
- RBAC access control
- Better separation of sensitive data
- Optional encryption at rest
- Secure mounting into containers
- tmpfs storage on nodes

---

# Task 5 – Use Secrets in a Pod

## Step 1 – Create Pod Manifest

Create file:

```bash
nano secret-pod.yaml
```

Add:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  containers:
  - name: busybox
    image: busybox

    command: ["/bin/sh", "-c"]
    args:
      - |
        echo "DB_USER=$DB_USER"

        echo "Mounted Secret Files:"
        ls /etc/db-credentials

        echo "Password:"
        cat /etc/db-credentials/DB_PASSWORD

        sleep 3600

    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: DB_USER

    volumeMounts:
    - name: secret-volume
      mountPath: /etc/db-credentials
      readOnly: true

  volumes:
  - name: secret-volume
    secret:
      secretName: db-credentials
```

---

## Step 2 – Apply Manifest

```bash
kubectl apply -f secret-pod.yaml
```

---

## Step 3 – Verify Secret Usage

```bash
kubectl logs secret-pod
```

Expected Output:

```text
DB_USER=admin

Mounted Secret Files:
DB_PASSWORD
DB_USER

Password:
s3cureP@ssw0rd
```

---

# Important Observation

Inside the container:
- Secret values are automatically decoded
- Mounted Secret files contain plaintext values
- NOT base64 encoded values

---

# Task 6 – Update ConfigMap and Observe Propagation

This demonstrates:
- Volume-mounted ConfigMaps update automatically
- Environment variables do NOT update automatically

---

## Step 1 – Create ConfigMap

```bash
kubectl create configmap live-config \
  --from-literal=message=hello
```

---

## Step 2 – Create Pod Manifest

Create file:

```bash
nano live-config-pod.yaml
```

Add:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: live-config-pod
spec:
  containers:
  - name: busybox
    image: busybox

    command: ["/bin/sh", "-c"]
    args:
      - |
        while true
        do
          echo "Current Message:"
          cat /config/message
          sleep 5
        done

    volumeMounts:
    - name: config-volume
      mountPath: /config

  volumes:
  - name: config-volume
    configMap:
      name: live-config
```

---

## Step 3 – Apply Manifest

```bash
kubectl apply -f live-config-pod.yaml
```

---

## Step 4 – Watch Logs

```bash
kubectl logs -f live-config-pod
```

Expected Output:

```text
Current Message:
hello
```

---

## Step 5 – Update ConfigMap

```bash
kubectl patch configmap live-config \
  --type merge \
  -p '{"data":{"message":"world"}}'
```

---

## Step 6 – Observe Automatic Update

After 30–60 seconds:

```text
Current Message:
world
```

No pod restart required.

---

# ConfigMap Update Behavior

| Method | Auto Update |
|---|---|
| Environment Variables | No |
| Volume Mounts | Yes |

---

# Task 7 – Clean Up

## Delete Pods

```bash
kubectl delete pod configmap-env-pod
kubectl delete pod nginx-config-pod
kubectl delete pod secret-pod
kubectl delete pod live-config-pod
```

---

## Delete ConfigMaps

```bash
kubectl delete configmap app-config
kubectl delete configmap nginx-config
kubectl delete configmap live-config
```

---

## Delete Secret

```bash
kubectl delete secret db-credentials
```

---

# Summary

## ConfigMaps
Used for:
- Non-sensitive configuration
- Environment variables
- Config files

## Secrets
Used for:
- Passwords
- API keys
- Tokens
- Sensitive data

---

# Key Learnings

- ConfigMaps store plain text data
- Secrets are base64 encoded
- Base64 is NOT encryption
- ConfigMaps and Secrets can be:
  - Injected as environment variables
  - Mounted as volumes
- Volume-mounted ConfigMaps update automatically
- Environment variables do not update after pod startup

---

# Directory Structure

```text
2026/
└── day-54/
    ├── day-54-configmaps-secrets.md
    ├── configmap-env-pod.yaml
    ├── nginx-config-pod.yaml
    ├── secret-pod.yaml
    ├── live-config-pod.yaml
    └── default.conf
```

---

# Git Commands

```bash
mkdir -p 2026/day-54

mv *.yaml 2026/day-54/
mv default.conf 2026/day-54/

git add .
git commit -m "Added Day 54 Kubernetes ConfigMaps and Secrets"
git push origin main
```

---
