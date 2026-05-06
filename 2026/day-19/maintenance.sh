
#!/bin/bash


LOG_FILE="/var/log/maintenance.sh"

echo "----- $(date) -----" $LOG_FILE

#Run the rotation
/home/ubuntu/shell-scripting/log_rotate.sh /var/log/nginx >> $LOG_FILE 2>&1

#Run backup
/home/ubuntu/shell-scripting/backup.sh /home/ubuntu/shell-scripting /home/ubuntu/backup-dir >> $LOG_FILE

echo "Maintenance completed" >> $LOG_FILE
