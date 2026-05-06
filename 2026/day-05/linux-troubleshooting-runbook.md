# Day 05 – Linux Troubleshooting Runbook

## 🔧 Target Service / Process


## 🖥️ Environment Basics
### 1. uname -a
Output:

Observation:
System is running Linux kernel version X on architecture X.

### 2. cat /etc/os-release
Output:

Observation:
OS is Ubuntu XX / CentOS XX (confirming environment details).

---

## 📁 Filesystem Sanity
### 3. mkdir /tmp/runbook-demo
### 4. cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo
Output:

Observation:
Filesystem is writable. File copy successful, permissions look normal.

---

## ⚙️ CPU & Memory Snapshot
### 5. top (or htop)
Output:

Observation:
CPU usage is around X%. sshd is using minimal resources.

### 6. free -h
Output:

Observation:
Memory usage is healthy. No swap pressure observed.

## 💾 Disk & IO Snapshot
### 7. df -h
Output:
Observation:
Disk usage is below critical threshold (<80%).

### 8. du -sh /var/log
Output:
Observation:
Log directory size is manageable, no excessive growth.

---

## 🌐 Network Snapshot
### 9. ss -tulpn | grep ssh
Output:
Observation:
sshd is listening on port 22.

### 10. ping -c 4 localhost
Output:
Observation:
Network stack is working correctly (no packet loss).

---

## 📜 Logs Reviewed
### 11. journalctl -u ssh -n 50
Output:
Observation:
No recent errors found. Normal login activity observed.

### 12. tail -n 50 /var/log/auth.log
Output:

Observation:
Authentication logs show expected behavior. No suspicious attempts.

---

## 🔍 Quick Findings

- System resources (CPU, memory, disk) are within normal limits  
- sshd service is running and listening correctly  
- No critical errors found in recent logs  
- System appears healthy  

---

## 🚨 If This Worsens (Next Steps)

1. Restart service safely: