# Day 17 – Shell Scripting: Loops, Arguments & Error Handling

## 📌 Overview
Today I practiced shell scripting concepts like loops, command-line arguments, automation, and error handling.  
The goal was to move from basic commands to writing scripts that can automate real tasks.

---

## 🔁 Task 1: For Loop

### for_loop.sh
```bash
#!/bin/bash

fruits=("Apple" "Banana" "Mango" "Orange" "Grapes")

for fruit in "${fruits[@]}"
do
  echo "Fruit: $fruit"
done
Output
Fruit: Apple
Fruit: Banana
Fruit: Mango
Fruit: Orange
Fruit: Grapes
count.sh
#!/bin/bash

for i in {1..10}
do
  echo $i
done
Output
1
2
3
4
5
6
7
8
9
10


🔁 Task 2: While Loop
countdown.sh
#!/bin/bash

echo "Enter a number:"
read num

while [ $num -ge 0 ]
do
  echo $num
  ((num--))
done

echo "Done!"
Output (Example)
Enter a number:
5
5
4
3
2
1
0
Done!


📥 Task 3: Command-Line Arguments
greet.sh
#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage: ./greet.sh <name>"
else
  echo "Hello, $1!"
fi
Output
./greet.sh Kiran
Hello, Kiran!
args_demo.sh
#!/bin/bash

echo "Script Name: $0"
echo "Total Arguments: $#"
echo "All Arguments: $@"
Output
Script Name: ./args_demo.sh
Total Arguments: 3
All Arguments: one two three


📦 Task 4: Install Packages via Script
install_packages.sh
#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi

packages=("nginx" "curl" "wget")

for pkg in "${packages[@]}"
do
  if dpkg -s "$pkg" &> /dev/null
  then
    echo "$pkg is already installed"
  else
    echo "Installing $pkg..."
    apt update -y
    apt install -y "$pkg"
  fi
done
Output (Example)
nginx is already installed
Installing curl...
Installing wget...


⚠️ Task 5: Error Handling
safe_script.sh
#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"
cd /tmp/devops-test || echo "Failed to enter directory"
touch testfile.txt || echo "Failed to create file"

echo "Script completed successfully"
Output (Example)
Directory already exists
Script completed successfully
🧠