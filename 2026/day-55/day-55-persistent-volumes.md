# Day 55 – Persistent Volumes (PV) and Persistent Volume Claims (PVC)

## Introduction

Containers are ephemeral by default. When a Pod is deleted or recreated, all data inside the container filesystem is lost. This is a major problem for applications like databases, file uploads, logs, and any application that needs persistent storage.

Kubernetes solves this using:

* Persistent Volumes (PV)
* Persistent Volume Claims (PVC)
* StorageClasses

---

# Objective

In this lab:

* Demonstrate data loss with ephemeral storage
* Create a PersistentVolume manually
* Create a PersistentVolumeClaim
* Mount persistent storage into Pods
* Explore dynamic provisioning using StorageClasses
* Understand reclaim policies and access modes

---

# Kubernetes Storage Architecture

```text
Pod → PVC → PV → Physical Storage
```

### Explanation

* Pod consumes storage
* PVC requests storage
* PV provides storage
* Physical storage can be:

  * hostPath
  * AWS EBS
  * Azure Disk
  * NFS
  * Ceph
  * Local storage

---

# Task 1 – Demonstrate Ephemeral Storage

## Create Pod Using emptyDir

File: `ephemeral-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ephemeral-pod
spec:
  containers:
  - name: app
    image: busybox
    command:
      - sh
      - -c
      - |
        echo "Created at $(date)" > /data/message.txt
        sleep 3600

    volumeMounts:
    - name: temp-storage
      mountPath: /data

  volumes:
  - name: temp-storage
    emptyDir: {}
```

---

## Apply the Pod

```bash
kubectl apply -f ephemeral-pod.yaml
```

Check Pod:

```bash
kubectl get pods
```

---

## Verify Data Exists

```bash
kubectl exec -it ephemeral-pod -- cat /data/message.txt
```

Example output:

```text
Created at Wed May 28 10:00:00 UTC 2026
```

---

## Delete the Pod

```bash
kubectl delete pod ephemeral-pod
```

Recreate:

```bash
kubectl apply -f ephemeral-pod.yaml
```

Check file again:

```bash
kubectl exec -it ephemeral-pod -- cat /data/message.txt
```

---

## Observation

The timestamp changes after Pod recreation because:

* `emptyDir` exists only while the Pod exists
* Pod deletion removes the volume
* New Pod gets a fresh empty volume

---

# Task 2 – Create PersistentVolume (Static Provisioning)

## Create PV Manifest

File: `pv.yaml`

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: manual-pv
spec:
  capacity:
    storage: 1Gi

  accessModes:
    - ReadWriteOnce

  persistentVolumeReclaimPolicy: Retain

  hostPath:
    path: /tmp/k8s-pv-data
```

---

## Apply PV

```bash
kubectl apply -f pv.yaml
```

Check PV:

```bash
kubectl get pv
```

Expected:

```text
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS
manual-pv   1Gi        RWO            Retain           Available
```

---

# PV Field Explanation

## Capacity

```yaml
capacity:
  storage: 1Gi
```

Defines storage size.

---

## Access Modes

```yaml
accessModes:
  - ReadWriteOnce
```

### Access Modes

| Mode                | Meaning                  |
| ------------------- | ------------------------ |
| ReadWriteOnce (RWO) | Read-write by one node   |
| ReadOnlyMany (ROX)  | Read-only by many nodes  |
| ReadWriteMany (RWX) | Read-write by many nodes |

---

## Reclaim Policy

```yaml
persistentVolumeReclaimPolicy: Retain
```

Means:

* PV and data remain after PVC deletion
* Manual cleanup required

---

## hostPath

```yaml
hostPath:
  path: /tmp/k8s-pv-data
```

Uses local node filesystem.

Useful for:

* Learning
* Minikube
* Local testing

Not recommended for production.

---

# Task 3 – Create PersistentVolumeClaim

## Create PVC Manifest

File: `pvc.yaml`

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-pvc
spec:
  accessModes:
    - ReadWriteOnce

  resources:
    requests:
      storage: 500Mi
```

---

## Apply PVC

```bash
kubectl apply -f pvc.yaml
```

Check PVC:

```bash
kubectl get pvc
```

Expected:

```text
NAME      STATUS   VOLUME      CAPACITY
app-pvc   Bound    manual-pv   1Gi
```

Check PV:

```bash
kubectl get pv
```

Expected:

```text
manual-pv   Bound
```

---

# How PV and PVC Matching Works

Kubernetes matches:

* Requested storage size
* Access modes
* StorageClass

PVC requested:

* 500Mi
* ReadWriteOnce

PV provided:

* 1Gi
* ReadWriteOnce

So Kubernetes successfully bound them.

---

# Task 4 – Use PVC in a Pod

## Create Pod Using PVC

File: `persistent-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: persistent-pod
spec:
  containers:
  - name: app
    image: busybox
    command:
      - sh
      - -c
      - |
        echo "Pod started at $(date)" >> /data/message.txt
        sleep 3600

    volumeMounts:
    - name: persistent-storage
      mountPath: /data

  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: app-pvc
```

---

## Apply Pod

```bash
kubectl apply -f persistent-pod.yaml
```

Check data:

```bash
kubectl exec -it persistent-pod -- cat /data/message.txt
```

---

## Delete and Recreate Pod

```bash
kubectl delete pod persistent-pod
```

Recreate:

```bash
kubectl apply -f persistent-pod.yaml
```

Check file again:

```bash
kubectl exec -it persistent-pod -- cat /data/message.txt
```

Expected:

```text
Pod started at 10:20
Pod started at 10:30
```

---

# Observation

Data persists because:

* PVC still exists
* PV still exists
* Storage survives Pod deletion

---

# Task 5 – StorageClasses and Dynamic Provisioning

## Check StorageClasses

```bash
kubectl get storageclass
```

Cluster output:

```text
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer
```

---

## Describe StorageClass

```bash
kubectl describe storageclass standard
```

Important values:

### Provisioner

```text
rancher.io/local-path
```

Creates storage dynamically using local node paths.

---

### Reclaim Policy

```text
Delete
```

Automatically removes PV when PVC is deleted.

---

### VolumeBindingMode

```text
WaitForFirstConsumer
```

PV creation waits until a Pod uses the PVC.

---

# Immediate vs WaitForFirstConsumer

| Mode                 | Behavior                     |
| -------------------- | ---------------------------- |
| Immediate            | PV created immediately       |
| WaitForFirstConsumer | Waits until Pod consumes PVC |

---

# Task 6 – Dynamic Provisioning

## Create Dynamic PVC

File: `dynamic-pvc.yaml`

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  accessModes:
    - ReadWriteOnce

  storageClassName: standard

  resources:
    requests:
      storage: 1Gi
```

---

## Apply PVC

```bash
kubectl apply -f dynamic-pvc.yaml
```

Check PVC:

```bash
kubectl get pvc
```

Initially:

```text
dynamic-pvc   Pending
```

This happens because:

* StorageClass uses `WaitForFirstConsumer`
* No Pod is using PVC yet

---

## Create Pod Using Dynamic PVC

File: `dynamic-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dynamic-pod
spec:
  containers:
  - name: app
    image: busybox
    command:
      - sh
      - -c
      - |
        echo "Dynamic storage works at $(date)" >> /data/message.txt
        sleep 3600

    volumeMounts:
    - name: storage
      mountPath: /data

  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: dynamic-pvc
```

---

## Apply Pod

```bash
kubectl apply -f dynamic-pod.yaml
```

Check PVC again:

```bash
kubectl get pvc
```

Now expected:

```text
dynamic-pvc   Bound
```

Check PVs:

```bash
kubectl get pv
```

Expected:

* `manual-pv`
* `pvc-xxxxxxxx`

---

# Dynamic Provisioning Workflow

```text
Pod → PVC → StorageClass → Dynamic PV → Pod Running
```

Kubernetes automatically creates the PV.

---

# Task 7 – Cleanup

## Delete Pods

```bash
kubectl delete pod persistent-pod dynamic-pod
```

---

## Delete PVCs

```bash
kubectl delete pvc app-pvc dynamic-pvc
```

---

## Check PVs

```bash
kubectl get pv
```

Expected:

```text
manual-pv   Released
```

Dynamic PV disappears automatically.

---

# Why?

## Manual PV

Used reclaim policy:

```yaml
Retain
```

So Kubernetes keeps the PV and data.

---

## Dynamic PV

Used reclaim policy:

```yaml
Delete
```

So Kubernetes deletes the PV automatically.

---

# Delete Remaining PV

```bash
kubectl delete pv manual-pv
```

---

# PV Lifecycle

```text
Available → Bound → Released
```

---

# Common Troubleshooting

## PVC Stuck in Pending

Check:

* Capacity mismatch
* Access mode mismatch
* Missing StorageClass
* No available PV
* WaitForFirstConsumer behavior

---

## View Detailed Events

```bash
kubectl describe pvc app-pvc
```

---

# Key Learnings

* Containers lose data after deletion
* `emptyDir` is temporary storage
* PV provides persistent storage
* PVC requests storage
* StorageClasses enable automation
* Dynamic provisioning automatically creates PVs
* Reclaim policies control cleanup behavior

---

# Static vs Dynamic Provisioning

| Static Provisioning       | Dynamic Provisioning                |
| ------------------------- | ----------------------------------- |
| Admin creates PV manually | Kubernetes creates PV automatically |
| More manual work          | Automated                           |
| Good for learning         | Preferred in production             |

---

# Difference Between PV and PVC

| PV               | PVC                  |
| ---------------- | -------------------- |
| Actual storage   | Request for storage  |
| Cluster-wide     | Namespace-scoped     |
| Created by admin | Created by developer |

---

# Folder Structure

```text
2026/
└── day-55/
    ├── ephemeral-pod.yaml
    ├── pv.yaml
    ├── pvc.yaml
    ├── persistent-pod.yaml
    ├── dynamic-pvc.yaml
    ├── dynamic-pod.yaml
    └── day-55-persistent-volumes.md
```

---

# Git Commands

```bash
git add .
git commit -m "Day 55 - Persistent Volumes and Persistent Volume Claims"
git push origin main
```

---

# Conclusion

Today we learned:

* Why container storage is ephemeral
* How Kubernetes provides persistent storage
* How PVs and PVCs work together
* Static vs dynamic provisioning
* StorageClasses and reclaim policies
* Real-world Kubernetes storage behavior

Persistent storage is critical for running stateful applications reliably in Kubernetes.
