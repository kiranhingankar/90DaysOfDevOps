#!/bin/bash


#---------------------
# Log Analyzer Script
# --------------------


# Task 1: Input validation
if [ $# -eq 0 ]; then
        echo "Error: No log file provided."
        echo "Usage: $0 <log_file>"
        exit 1
fi

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
        echo "Error: File does not exist!"
        exit 1
fi

# Date for report
DATE=$(date +%Y-%m-%d)
REPORT_FILE="log_report_${DATE}.txt"

echo "Analyzing log file: $LOG_FILE"

#Task 2: Error Count
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)
echo "Total Erros: $ERROR_COUNT"

# Task 3: Critical events
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE")

echo -e "\n--- Critical Events ---"
echo "$CRITICAL_EVENTS"

# Task 4: Top 5 Error Messages
TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" \
        | awk '{$1=$2=$3=""; print}' \
        | sort | uniq -c | sort -rn | head -5 )

echo -e "\n--- Top 5 Error Messages ---"
echo "$TOP_ERRORS"

# Total lines
TOTAL_LINES=$(wc -l < "$LOG_FILE")

# Task 5: Generate Report
{
        echo "===== Log Analysis Report ====="
        echo "Date: $DATE"
        echo "Log File: $LOG_FILE"
        echo "Total Lines: $TOTAL_LINES"
        echo "Total Errors: $ERROR_COUNT"

        echo -e "\n--- Top 5 Error Messages ---"
        echo "$TOP_ERRORS"

        echo -e "\n--- Critical Events ---"
        echo "$CRITICAL_EVENTS"

} > "$REPORT_FILE"

echo "📄 Report generated: $REPORT_FILE"

# Task 6: Archive Logs
ARCHIVE_DIR="archive"
mkdir -p "$ARCHIVE_DIR"
mv "$LOG_FILE" "$ARCHIVE_DIR/"

echo "Log file move to $ARCHIVE_DIR"
