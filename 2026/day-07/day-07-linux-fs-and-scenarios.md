### Part 1: Linux File System Hierarchy

# / (root) - The top-level directory; everything starts from here
Example: bin, etc, home
I would use this when navigating the full system structure

# /home - Contains personal directories for users
Example: user/, files like .bashrc
I would use this when managing user files

# /root - Home directory of the root (admin) user
Example: root-specific configs
I would use this when working with administrative tasks

# /etc - Stores system configuration files
Example: hostname, passwd, ssh/
I would use this when changing system settings

# /var/log - Contains system and application logs
Example: syslog, auth.log
I would use this when troubleshooting errors

# /tmp - Temporary files stored for short-term use
Example: temp cache files
I would use this when applications need temporary storage

# /bin - Essential system binaries (commands)
Example: ls, cp, mv
I would use this when running basic system commands

# /usr/bin - User-level command binaries
Example: git, python
I would use this when executing installed programs

# /opt - Third-party or optional software
Example: custom applications
I would use this when installing external tools



# Hands on task :

ubuntu@ip-172-31-22-32:/$ du -sh /var/log/* 2>/dev/null | sort -h | tail -5
48K     /var/log/dmesg
60K     /var/log/kern.log
132K    /var/log/cloud-init.log
152K    /var/log/syslog
17M     /var/log/journal
ubuntu@ip-172-31-22-32:/$ cat /etc/hostname
ip-172-31-22-32
ubuntu@ip-172-31-22-32:/$ ls -la ~
total 68316
drwxr-x--- 5 ubuntu ubuntu     4096 Apr 28 15:02 .
drwxr-xr-x 3 root   root       4096 Apr 28 14:23 ..
-rw------- 1 ubuntu ubuntu       61 Apr 28 14:32 .Xauthority
-rw-r--r-- 1 ubuntu ubuntu      220 Mar 31  2024 .bash_logout
-rw-r--r-- 1 ubuntu ubuntu     3771 Mar 31  2024 .bashrc
drwx------ 2 ubuntu ubuntu     4096 Apr 28 14:32 .cache
-rw------- 1 ubuntu ubuntu       20 Apr 28 15:02 .lesshst
-rw-r--r-- 1 ubuntu ubuntu      807 Mar 31  2024 .profile
drwx------ 2 ubuntu ubuntu     4096 Apr 28 14:24 .ssh
-rw-r--r-- 1 ubuntu ubuntu        0 Apr 28 14:33 .sudo_as_admin_successful
drwxr-xr-x 3 ubuntu ubuntu     4096 Apr 27 19:20 aws
-rw-rw-r-- 1 ubuntu ubuntu 69908342 Apr 28 14:35 awscliv2.zip
-rw-r--r-- 1 ubuntu ubuntu       45 Apr 28 14:41 notes.txt
ubuntu@ip-172-31-22-32:/$



### Part 2: Scenario-Based Practice

🔹 Service failure after reboot
→ 𝘀𝘆𝘀𝘁𝗲𝗺𝗰𝘁𝗹 𝘀𝘁𝗮𝘁𝘂𝘀
→ 𝗷𝗼𝘂𝗿𝗻𝗮𝗹𝗰𝘁𝗹 -𝘂
→ 𝘀𝘆𝘀𝘁𝗲𝗺𝗰𝘁𝗹 𝗶𝘀-𝗲𝗻𝗮𝗯𝗹𝗲𝗱

🔹 High CPU usage issue
→ 𝘁𝗼𝗽
→ 𝗽𝘀 𝗮𝘂𝘅 --𝘀𝗼𝗿𝘁=-%𝗰𝗽𝘂

🔹 Debugging logs
→ 𝗷𝗼𝘂𝗿𝗻𝗮𝗹𝗰𝘁𝗹 -𝗳
→ 𝗔𝗻𝗮𝗹𝘆𝘇𝗲𝗱 /𝘃𝗮𝗿/𝗹𝗼𝗴

🔹 Permission denied error
→ 𝗹𝘀 -𝗹 𝗳𝗶𝗹𝗲𝗻𝗮𝗺𝗲
→ 𝗰𝗵𝗺𝗼𝗱 +𝘅 𝗳𝗶𝗹𝗲𝗻𝗮𝗺𝗲


✅ Scenario 1: Service Not Starting

Step 1:
Command:systemctl status nginx
Why: Check if the service is failed or inactive

Step 2:
Command:journalctl -u nginx -n 50
Why: View recent logs for error messages

Step 3:
Command:systemctl is-enabled nginx
Why: Check if service starts on boot

Step 4:
Command:systemctl restart nginx
Why: Try restarting after identifying issue

✅ Scenario 2: High CPU Usage

Step 1:
Command:top
Why: View live CPU usage

Step 2:
Command:ps aux --sort=-%cpu | head -10
Why: Identify top CPU-consuming processes

Step 3:
Command:htop
Why: Better visual monitoring (if installed)


✅ Scenario 3: Finding Service Logs

Step 1:
Command:systemctl status docker
Why: Check service status

Step 2:
Command:journalctl -u docker -n 50
Why: View recent logs

Step 3:
Command:journalctl -u docker -f
Why: Monitor logs in real time


✅ Scenario 4: File Permissions Issue

Step 1:
ls -l /home/user/backup.sh
Why: Check permissions

Step 2:
chmod +x /home/user/backup.sh
Why: Add execute permission

Step 3:
ls -l /home/user/backup.sh
Why: Verify changes

Step 4:
./backup.sh
Why: Execute script