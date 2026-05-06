# Day 12 – Revision & Breather

## 🔁 Goal
Consolidate learning from Days 01–11 and strengthen fundamentals.

---

## 🧠 Mindset & Plan Review
- My original goal was to build strong Linux + DevOps fundamentals.
- Progress feels consistent, but I need more hands-on repetition.
- Adjustment: Spend more time practicing commands instead of just reading.

---

## ⚙️ Processes & Services (Practice)
Commands used:
- `ps aux` → Viewed running processes
- `systemctl status ssh` → Checked SSH service status
- `journalctl -u ssh` → Viewed logs for SSH service

### Observations:
- `ps aux` gives detailed process info (PID, CPU, memory)
- `systemctl status` shows whether service is active/running
- `journalctl` helps debug issues with logs

---

## 📁 File Skills Practice
Commands practiced:
- `echo "Hello DevOps" >> file.txt` → Appended text
- `chmod 755 file.txt` → Changed permissions
- `ls -l` → Verified permissions

### Observations:
- Permission format became clearer (`rwxr-xr-x`)
- Appending vs overwriting is important (`>>` vs `>`)

---

## 📌 Cheat Sheet – Top 5 Commands
These are my go-to commands during incidents:
1. `ls -l` → Check files and permissions
2. `cd` → Navigate directories quickly
3. `ps aux` → Inspect running processes
4. `systemctl status` → Check service health
5. `journalctl -xe` → Debug system issues

---

## 👤 User/Group Practice
Scenario:
- Created a new user and changed file ownership

Commands:
- `sudo useradd devuser`
- `sudo chown devuser file.txt`
- `id devuser`
- `ls -l`

### Verification:
- Ownership successfully changed
- User ID and group confirmed

---

## ✅ Mini Self-Check

### 1) Top 3 Time-Saving Commands
- `ls -l` → Quick visibility of files & permissions  
- `ps aux` → Helps identify running processes instantly  
- `systemctl status` → Fast way to check service health  

---

### 2) How to Check Service Health
Commands I would run:
- `systemctl status <service>`
- `ps aux | grep <service>`
- `journalctl -u <service>`

---

### 3) Safe Permission & Ownership Change
Example:
```bash
sudo chown user:group file.txt
chmod 644 file.txt