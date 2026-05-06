
#!/bin/bash


SRC=$1
DEST=$2

if [ -z "$SRC" ] || [ -z "$DEST" ]; then
        echo "Usage: $0 <souce_dir> <backup_dir>"
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
        echo "Backup created : $ARCHIVE"
        echo "Size: $SIZE"
else
        echo "Backupt failed!"
        exit 1
fi

#Delete backupt older than 14 days
find "$DEST" -name "backup-*.tar.gz" -mtime +14 -delete
