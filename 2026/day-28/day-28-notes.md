# Day 28 – Revision Notes

## 📌 Overview
Day 28 was focused on revision of everything covered from Day 1 to Day 27.  
The goal was to identify gaps, strengthen weak areas, and build deeper understanding.

---

## ✅ Self-Assessment

### 🐧 Linux
| Topic | Status |
|------|--------|
| File system navigation | ✅ Confident |
| Process management | ✅ Confident |
| systemd services | ⚠️ Need practice |
| Text editors (vim/nano) | ✅ Confident |
| System troubleshooting | ✅ Confident |
| File system hierarchy | ⚠️ Need revision |
| Users & groups | ✅ Confident |
| File permissions | ✅ Confident |
| Ownership (chown/chgrp) | ✅ Confident |
| LVM | ⚠️ Need practice |
| Networking commands | ✅ Confident |
| DNS & subnet basics | ⚠️ Need revision |

---

### 🖥️ Shell Scripting
| Topic | Status |
|------|--------|
| Variables & arguments | ✅ Confident |
| Conditionals | ✅ Confident |
| Loops | ✅ Confident |
| Functions | ⚠️ Need practice |
| Text processing (grep/awk/sed) | ⚠️ Need practice |
| Error handling | ⚠️ Need practice |
| Crontab | ✅ Confident |

---

### 🔧 Git & GitHub
| Topic | Status |
|------|--------|
| Basic Git workflow | ✅ Confident |
| Branching | ✅ Confident |
| Push/Pull | ✅ Confident |
| Clone vs Fork | ✅ Confident |
| Merge strategies | ⚠️ Need revision |
| Rebase | ⚠️ Need practice |
| Stash | ✅ Confident |
| Cherry-pick | ⚠️ Need revision |
| Reset vs Revert | ⚠️ Need revision |
| Branching strategies | ⚠️ Need revision |
| GitHub CLI | ✅ Confident |

---

## 🔁 Revisited Topics

### 1. LVM (Logical Volume Management)
- Learned structure: Physical Volume → Volume Group → Logical Volume  
- Understood resizing volumes without downtime  
- Need more hands-on practice  

### 2. Git Rebase vs Merge
- Rebase creates a clean linear history  
- Merge preserves commit history with merge commits  
- Rebase is useful for cleaner history, merge is safer for teams  

### 3. Shell Error Handling
- `set -e` → Exit script on error  
- `set -u` → Error on undefined variables  
- `set -o pipefail` → Fail if any command in pipeline fails  

---

## ⚡ Quick-Fire Answers

1. `chmod 755 script.sh`  
   → Owner: read, write, execute | Others: read, execute  

2. Process vs Service  
   → Process = running program  
   → Service = background process managed by system  

3. Find process using port 8080  
   ```bash
   lsof -i :8080
   ss -tulnp | grep 8080
set -euo pipefail
→ Makes script safer by stopping on errors and undefined variables
git reset --hard vs git revert
→ Reset removes history
→ Revert creates a new commit to undo changes
Recommended branching strategy
→ GitHub Flow (simple and effective for small teams)
git stash
→ Temporarily saves uncommitted changes

Schedule script at 3 AM

0 3 * * * /path/to/script.sh
git fetch vs git pull
→ Fetch downloads changes
→ Pull = fetch + merge
LVM
→ Flexible disk management system for resizing and better storage handling
🧠 Teach Back
What is Git Branching?

Git branching allows developers to create a separate version of their code to work on new features.
This keeps the main code safe and stable.
Once the changes are tested, they are merged back into the main branch.