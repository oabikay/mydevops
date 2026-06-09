#!/bin/bash

LOG_FILE="/var/log/s3_sync.log"
LOCK_FILE="/tmp/s3_sync.lock"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Stopping S3 sync..." | tee -a "$LOG_FILE"
pkill -f "aws s3 sync"
rm -f "$LOCK_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] S3 sync stopped." | tee -a "$LOG_FILE"