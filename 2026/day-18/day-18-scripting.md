# Day 18 – Shell Scripting: Functions & Intermediate Concepts

## 📌 Overview

Today focused on writing cleaner, reusable, and production-ready shell scripts using:

* Functions
* Strict mode (`set -euo pipefail`)
* Return values
* Local variables

---

# 🧩 Task 1: Basic Functions

## Script: `functions.sh`

```bash
#!/bin/bash

greet() {
    echo "Hello, $1!"
}

add() {
    sum=$(( $1 + $2 ))
    echo "Sum: $sum"
}

# Calling functions
greet "Kiran"
add 5 10
```

## Output

```
Hello, Kiran!
Sum: 15
```

---

# 🧩 Task 2: Disk & Memory Check

## Script: `disk_check.sh`

```bash
#!/bin/bash

check_disk() {
    echo "Disk Usage:"
    df -h /
}

check_memory() {
    echo "Memory Usage:"
    free -h
}

# Main
check_disk
echo ""
check_memory
```

## Output

```
Disk Usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   20G   28G  42% /

Memory Usage:
              total        used        free
Mem:           8Gi         3Gi         4Gi
```

---

# 🧩 Task 3: Strict Mode

## Script: `strict_demo.sh`

```bash
#!/bin/bash
set -euo pipefail

echo "Demo for strict mode"

# Undefined variable (set -u)
echo "$UNDEFINED_VAR"

# Command failure (set -e)
false

# Pipe failure (pipefail)
cat missing.txt | grep "test"
```

## Output

```
Demo for strict mode
./strict_demo.sh: line 7: UNDEFINED_VAR: unbound variable
```

## Explanation

* `set -e` → Exit immediately if any command fails
* `set -u` → Treat unset variables as errors
* `set -o pipefail` → Fail if any command in a pipeline fails

---

# 🧩 Task 4: Local Variables

## Script: `local_demo.sh`

```bash
#!/bin/bash

global_var="I am global"

use_local() {
    local local_var="I am local"
    echo "$local_var"
}

use_global() {
    global_var="Modified global"
}

use_local
echo "Outside function: ${local_var:-Not Accessible}"

use_global
echo "Global after function: $global_var"
```

## Output

```
I am local
Outside function: Not Accessible
Global after function: Modified global
```

---

# 🧩 Task 5: System Info Reporter

## Script: `system_info.sh`

```bash
#!/bin/bash
set -euo pipefail

print_header() {
    echo "=============================="
    echo "$1"
    echo "=============================="
}

system_info() {
    print_header "System Info"
    hostname
    uname -a
}

uptime_info() {
    print_header "Uptime"
    uptime
}

disk_usage() {
    print_header "Top Disk Usage"
    du -ah / 2>/dev/null | sort -rh | head -n 5
}

memory_usage() {
    print_header "Memory Usage"
    free -h
}

cpu_usage() {
    print_header "Top CPU Processes"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

main() {
    system_info
    uptime_info
    disk_usage
    memory_usage
    cpu_usage
}

main
```

## Sample Output

```
==============================
System Info
==============================
my-host
Linux version info...

==============================
Uptime
==============================
 10:30:01 up 2 days...

==============================
Top Disk Usage
==============================
/var/log...

==============================
Memory Usage
==============================
Mem: ...

==============================
Top CPU Processes
==============================
PID   CMD   %CPU
```

---

# 📚 Key Learnings

1. Functions make scripts reusable and cleaner
2. Strict mode prevents hidden bugs and improves reliability
3. Local variables avoid unexpected side effects

---

# 🚀 Conclusion

This day focused on moving from basic scripting to writing structured, reliable, and maintainable shell scripts using real DevOps practices.