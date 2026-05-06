# 🐚 Shell Scripting Cheat Sheet (With Purpose)A practical reference guide with **what + why + example** 🚀


---

## 📌 Quick Reference

| Topic | Key Syntax | Example |
|-------|-----------|---------|
| Variable | `VAR="value"` | `NAME="DevOps"` |
| Argument | `$1`, `$2` | `./script.sh arg1` |
| If | `if [ condition ]; then` | `if [ -f file ]; then` |
| For loop | `for i in list; do` | `for i in 1 2 3; do` |
| Function | `name() { ... }` | `greet() { echo "Hi"; }` |
| Grep | `grep pattern file` | `grep -i "error" log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}' /etc/passwd` |
| Sed | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` |

---

## 🧱 Basics

### Shebang
```bash
#!/bin/bash
👉 Tells system which interpreter to use for running the script.

Running a Script
chmod +x script.sh./script.shbash script.sh
👉 chmod +x → gives execute permission
👉 ./script.sh → runs script directly
👉 bash script.sh → runs via bash interpreter

Comments
# This is a commentecho "Hi" # inline comment
👉 Used to explain code (ignored during execution)

Variables
NAME="DevOps"echo $NAMEecho "$NAME"echo '$NAME'
👉 Store and reuse values
👉 "$VAR" → expands variable
👉 '$VAR' → treats as plain text

User Input
read NAME
👉 Takes input from user at runtime

Command-line Arguments
echo $0echo $1echo $#echo $@echo $?
👉 $0 → script name
👉 $1 → first argument
👉 $# → number of arguments
👉 $@ → all arguments
👉 $? → exit status of last command

🔀 Operators & Conditionals
String Comparison
[ "$a" = "$b" ][ "$a" != "$b" ][ -z "$a" ][ -n "$a" ]
👉 Compare text values
👉 -z → empty string
👉 -n → non-empty

Integer Comparison
[ $a -eq $b ][ $a -gt $b ]
👉 Compare numeric values

File Tests
[ -f file ][ -d dir ][ -r file ]
👉 Check file conditions
👉 -f → file exists
👉 -d → directory exists
👉 -r → readable

If-Else
if [ condition ]; then  echo "Yes"else  echo "No"fi
👉 Used for decision making in scripts

Logical Operators
[ cond ] && echo "True"[ cond ] || echo "False"
👉 Combine conditions
👉 && → AND
👉 || → OR

Case Statement
case $var in  start) echo "Start";;  stop) echo "Stop";;esac
👉 Cleaner alternative to multiple if-else

🔁 Loops
For Loop
for i in 1 2 3; do  echo $idone
👉 Iterate over list

While Loop
while read line; do  echo $linedone < file.txt
👉 Loop until condition is true

Until Loop
until [ $i -eq 5 ]; do  echo $idone
👉 Runs until condition becomes true

Break & Continue
breakcontinue
👉 break → exit loop
👉 continue → skip iteration

Loop Files
for file in *.log
👉 Process multiple files automatically

🧩 Functions
Define Function
greet() {  echo "Hello"}
👉 Group reusable logic

Pass Arguments
func() {  echo $1}
👉 Functions accept inputs like scripts

Return vs Echo
return 1echo "value"
👉 return → status code
👉 echo → actual output

Local Variables
local var=10
👉 Restrict variable scope inside function

🔍 Text Processing (Most Important in DevOps)
grep
grep -i "error" file
👉 Search text in files
👉 Used for logs, debugging

awk
awk '{print $1}' file
👉 Extract columns / structured data

sed
sed 's/old/new/g' file
👉 Modify text in stream

cut
cut -d: -f1 file
👉 Extract specific fields

sort
sort -n file
👉 Sort data

uniq
uniq -c file
👉 Remove duplicates / count

tr
tr 'a-z' 'A-Z'
👉 Transform characters

wc
wc -l file
👉 Count lines, words, characters

head / tail
head -n 5 filetail -f file
👉 View start/end of file
👉 tail -f → live logs

⚡ Useful One-Liners
# Delete Files Older Than 7 Days
find . -mtime +7 -delete

# Count Lines in Log Files
wc -l *.log

# Replace Text in Multiple Files
sed -i 's/old/new/g' *.txt

# Check if Service is Running
systemctl is-active nginx

# Monitor Disk Usage
df -h

# Parse CSV (First Column)
cut -d, -f1 file.csv

# Monitor logs
tail -f app.log | grep ERROR
👉 These save hours of manual work

🚨 Error Handling & Debugging
set -eset -uset -o pipefailset -x
👉 set -e → stop on error
👉 set -u → catch undefined vars
👉 pipefail → catch pipeline errors
👉 set -x → debug execution

Exit Codes
echo $?
👉 Check success/failure of command

Trap
trap 'echo Cleanup done' EXIT
👉 Run cleanup on script exit
