📄 day-16-shell-scripting.md
# Day 16 – Shell Scripting Basics

## 📌 Overview
Today I started my journey into shell scripting — a fundamental skill for automation in DevOps.

I learned how to:
- Use shebang (`#!/bin/bash`)
- Work with variables
- Take user input using `read`
- Write conditional logic using `if-else`

---

## 🧪 Task 1: Your First Script

### 📜 Script: hello.sh
```bash
#!/bin/bash
echo "Hello, DevOps!"
▶️ Run
chmod +x hello.sh
./hello.sh
✅ Output
Hello, DevOps!
❓ What if we remove the shebang?
The script may still run if executed with bash hello.sh
But ./hello.sh may fail or use a different shell (like sh)
Shebang ensures the correct interpreter is used

🧪 Task 2: Variables
📜 Script: variables.sh
#!/bin/bash

NAME="Kiran"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
✅ Output
Hello, I am Kiran and I am a DevOps Engineer
🔍 Single vs Double Quotes
echo 'Hello, I am $NAME'   # No variable expansion
echo "Hello, I am $NAME"   # Variable expands
📌 Difference:
' ' → Literal string (no variable substitution)
" " → Allows variable substitution


🧪 Task 3: User Input with read

📜 Script: greet.sh
#!/bin/bash

read -p "Enter your name: " NAME
read -p "Enter your favourite tool: " TOOL

echo "Hello $NAME, your favourite tool is $TOOL"
▶️ Sample Run
Enter your name: Kiran
Enter your favourite tool: Docker
Hello Kiran, your favourite tool is Docker


🧪 Task 4: If-Else Conditions
📜 Script: check_number.sh
#!/bin/bash

read -p "Enter a number: " NUM

if [ $NUM -gt 0 ]; then
    echo "Positive"
elif [ $NUM -lt 0 ]; then
    echo "Negative"
else
    echo "Zero"
fi
▶️ Output Example
Enter a number: -5
Negative
📜 Script: file_check.sh
#!/bin/bash

read -p "Enter filename: " FILE

if [ -f "$FILE" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi
▶️ Output Example
Enter filename: test.txt
File exists


🧪 Task 5: Combine It All
📜 Script: server_check.sh
#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status of $SERVICE? (y/n): " CHOICE

if [ "$CHOICE" = "y" ]; then
    systemctl status $SERVICE

    if systemctl is-active --quiet $SERVICE; then
        echo "$SERVICE is active"
    else
        echo "$SERVICE is not active"
    fi
else
    echo "Skipped."
fi
▶️ Output Example
Do you want to check the status of nginx? (y/n): y
nginx is active
📚 Key Learnings
Shebang is important
Ensures scripts run with the correct interpreter
Variables & Input Handling
Variables store reusable values
read allows dynamic user interaction
Conditional Logic
if-else enables decision-making in scripts
Useful for automation and system checks



🚀 Summary

Shell scripting is powerful for:
Automating repetitive tasks
Managing servers
Writing deployment scripts
This is the foundation of real-world DevOps workflows.