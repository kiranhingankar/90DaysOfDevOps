# Day 20 – Bash Scripting Challenge: Log Analyzer

## 📌 Overview
This script automates log file analysis by extracting errors, critical events, and generating a summary report.

---

## 🧠 Approach

### 1. Input Validation
- Checked if the argument is provided
- Verified if the file exists

### 2. Error Count
- Used:
  grep -Ei "ERROR|Failed" logfile | wc -l

### 3. Critical Events
- Extracted with line numbers:
  grep -n "CRITICAL" logfile

### 4. Top Error Messages
- Process:
  - Extract ERROR lines
  - Remove timestamp fields using awk
  - Sort and count frequency
  - Display top 5

### 5. Report Generation
- Stored output in:
  log_report_<date>.txt

### 6. Archiving
- Created archive directory
- Moved processed log file

---

## 🛠 Tools Used

- grep → search patterns
- awk → text processing
- sort → sorting
- uniq → counting duplicates
- wc → line count
- date → dynamic filename
- mv → file management

---

## 📊 Sample Output
