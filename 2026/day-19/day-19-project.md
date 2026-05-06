# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

## 📌 Overview

This project focuses on automating system maintenance tasks using shell scripting:

* Log rotation
* Server backup
* Cron scheduling
* Combined maintenance automation

---

# 🧩 Task 1: Log Rotation Script

## 📜 Script: `log_rotate.sh`

```bash
#!/bin/bash

LOG_DIR=$1

if [ -z "$LOG_DIR" ]; then
  echo "Usage: $0 <log_directory>"
  exit 1
fi

if [ ! -d "$LOG_DIR" ]; then
  echo "Error: Directory does not exist!"
  exit 1
fi

# Compress logs older than 7 days
COMPRESSED=$(find "$LOG_DIR" -name "*.log" -mtime +7 -exec gzip {} \; -print | wc -l)

# Delete compressed logs older than 30 days
DELETED=$(find "$LOG_DIR" -name "*.gz" -mtime +30 -delete -print | wc -l)

echo "Logs compressed: $COMPRESSED"
echo "Logs deleted: $DELETED"
```

## ▶️ Sample Output

```
Logs compressed: 5
Logs deleted: 2
```

---

# 🧩 Task 2: Server Backup Script

## 📜 Script: `backup.sh`

```bash
#!/bin/bash

SRC=$1
DEST=$2

if [ -z "$SRC" ] || [ -z "$DEST" ]; then
  echo "Usage: $0 <source_dir> <backup_dir>"
  exit 1
fi

if [ ! -d "$SRC" ]; then
  echo "Error: Source directory does not exist!"
  exit 1
fi

TIMESTAMP=$(date +%Y-%m-%d)
ARCHIVE="$DEST/backup-$TIMESTAMP.tar.gz"

mkdir -p "$DEST"

tar -czf "$ARCHIVE" "$SRC"

if [ $? -eq 0 ]; then
  SIZE=$(du -h "$ARCHIVE" | cut -f1)
  echo "Backup created: $ARCHIVE"
  echo "Size: $SIZE"
else
  echo "Backup failed!"
  exit 1
fi

# Delete backups older than 14 days
find "$DEST" -name "backup-*.tar.gz" -mtime +14 -delete
```

## ▶️ Sample Output

```
Backup created: /backup/backup-2026-05-02.tar.gz
Size: 120M
```

---

# 🧩 Task 3: Crontab

## 🔍 Check existing cron jobs

```bash
crontab -l
```

## ⏱️ Cron Syntax

```
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

## 📝 Cron Entries

### Run log rotation daily at 2 AM

```bash
0 2 * * * /path/to/log_rotate.sh /var/log/myapp
```

### Run backup every Sunday at 3 AM

```bash
0 3 * * 0 /path/to/backup.sh /source /backup
```

### Health check every 5 minutes

```bash
*/5 * * * * /path/to/health_check.sh
```

---

# 🧩 Task 4: Combined Maintenance Script

## 📜 Script: `maintenance.sh`

```bash
#!/bin/bash

LOG_FILE="/var/log/maintenance.log"

echo "----- $(date) -----" >> $LOG_FILE

# Run log rotation
/path/to/log_rotate.sh /var/log/myapp >> $LOG_FILE 2>&1

# Run backup
/path/to/backup.sh /source /backup >> $LOG_FILE 2>&1

echo "Maintenance completed" >> $LOG_FILE
```

## ⏱️ Cron Entry (Daily at 1 AM)

```bash
0 1 * * * /path/to/maintenance.sh
```

---

# 📚 Key Learnings

1. Automation saves time and reduces manual errors in system maintenance
2. `find`, `tar`, and `cron` are powerful tools for real-world DevOps tasks
3. Logging and error handling are essential for production-ready scripts

---

# 🚀 Conclusion

This project simulates real DevOps responsibilities by automating:

* Log cleanup
* Backup management
* Scheduled operations

---