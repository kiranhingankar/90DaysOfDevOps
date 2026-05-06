# Day 10 Challenge

## Files Created

* devops.txt
* notes.txt
* script.sh
* project/

## Permission Changes

### script.sh

* Before: -rw-r--r--
* After:  -rwxr-xr-x

### devops.txt

* Before: -rw-r--r--
* After:  -r--r--r--

### notes.txt

* Before: -rw-r--r--
* After:  -rw-r-----

### project/

* Permissions: drwxr-xr-x (755)

## Commands Used

* touch devops.txt
* echo "These are my DevOps notes" > notes.txt
* vim script.sh
* cat notes.txt
* vim -R script.sh
* head -n 5 /etc/passwd
* tail -n 5 /etc/passwd
* chmod +x script.sh
* chmod a-w devops.txt
* chmod 640 notes.txt
* mkdir project
* chmod 755 project

## What I Learned

1. File permissions control who can read, write, and execute files.
2. chmod can modify permissions using symbolic and numeric methods.
3. Execute permission is required to run scripts in Linux.
