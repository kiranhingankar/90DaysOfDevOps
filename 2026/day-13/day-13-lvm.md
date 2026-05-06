# Day 13 – Linux Volume Management (LVM)

## Commands Used

### Create Disk
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
losetup -fP /tmp/disk1.img
losetup -a

### Check Storage
lsblk
pvs
vgs
lvs
df -h

### Create PV
pvcreate /dev/loop4

### Create VG
vgcreate devops-vg /dev/loop4

### Create LV
lvcreate -L 500M -n app-data devops-vg

### Format
mkfs.ext4 /dev/devops-vg/app-data

### Mount
mkdir -p /mnt/app-data
mount /dev/devops-vg/app-data /mnt/app-data

### Extend Volume
lvextend -L +200M /dev/devops-vg/app-data
resize2fs /dev/devops-vg/app-data

### Confirm new Size
df -h /mnt/app-data
---

## What I Learned

1. LVM allows flexible storage management without downtime.
2. Logical volumes can be resized easily.
3. Storage can be extended dynamically without repartitioning.