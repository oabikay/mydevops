#!/bin/bash

# ============================================================
# S3 Sync Script — Multi-Directory, Throttled & Server-Friendly
# ============================================================

# --- CONFIG ---
BASE_DIR="/var/www/html"
S3_BUCKET="s3://icsportal-documents/backups"
LOG_FILE="/var/log/s3_sync.log"
LOCK_FILE="/tmp/s3_sync.lock"
AWS_PROFILE="default"

# --- DIRECTORIES TO SYNC ---
DIRS=(
    "$BASE_DIR/uploads"
    "$BASE_DIR/outsourcehr-admin/documents"
    "$BASE_DIR/outsourcehr-admin/upload"
    "$BASE_DIR/outsourcehr-admin/document"
    "$BASE_DIR/outsourcehr-admin/downloads"
    "$BASE_DIR/outsourcehr-admin/verified_document"
    "$BASE_DIR/onboarding/admin/pages/uploads_credentials"
)

# --- THROTTLE CONFIG ---
MAX_BANDWIDTH="2MB/s"        # Tune to ~50% of your upload speed
MAX_CONCURRENT="3"          # Keep low to avoid CPU/memory spikes
MULTIPART_THRESHOLD="64MB"
MULTIPART_CHUNKSIZE="16MB"
NICE_LEVEL=19               # Lowest CPU priority
IONICE_CLASS=3              # Idle I/O priority

# --- LOGGING ---
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# --- LOCK: prevent overlapping cron runs ---
if [ -f "$LOCK_FILE" ]; then
    log "ERROR: Another sync is already running. Exiting."
    exit 1
fi
touch "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# --- CHECKS ---
if ! command -v aws &> /dev/null; then
    log "ERROR: AWS CLI not found. Run: sudo apt install awscli"
    exit 1
fi

# --- APPLY AWS CLI TRANSFER LIMITS ---
aws configure set default.s3.max_bandwidth "$MAX_BANDWIDTH"
aws configure set default.s3.max_concurrent_requests "$MAX_CONCURRENT"
aws configure set default.s3.multipart_threshold "$MULTIPART_THRESHOLD"
aws configure set default.s3.multipart_chunksize "$MULTIPART_CHUNKSIZE"

log "=========================================================="
log "S3 Multi-Directory Sync Started"
log "Bandwidth cap: $MAX_BANDWIDTH | Concurrent: $MAX_CONCURRENT"
log "=========================================================="

# --- TRACK OVERALL RESULTS ---
SUCCESS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

# --- SYNC EACH DIRECTORY ---
for DIR in "${DIRS[@]}"; do

    # Derive S3 subpath from directory structure
    # e.g. /var/www/html/staffportal/uploads → s3://bucket/backups/staffportal/uploads
    RELATIVE_PATH="${DIR#$BASE_DIR/}"
    S3_TARGET="$S3_BUCKET/$RELATIVE_PATH"

    # Skip if directory doesn't exist
    if [ ! -d "$DIR" ]; then
        log "SKIP: $DIR does not exist on server — skipping."
        ((SKIP_COUNT++))
        continue
    fi

    # Skip if directory is empty
    if [ -z "$(ls -A "$DIR")" ]; then
        log "SKIP: $DIR is empty — skipping."
        ((SKIP_COUNT++))
        continue
    fi

    log "----------------------------------------------------------"
    log "Syncing: $DIR"
    log "     To: $S3_TARGET"
    log "----------------------------------------------------------"

    nice -n "$NICE_LEVEL" ionice -c "$IONICE_CLASS" \
        aws s3 sync "$DIR" "$S3_TARGET" \
        --profile "$AWS_PROFILE" \
        --exclude "*.tmp" \
        --exclude "*.log" \
        --exclude "*.php" \
        --exclude ".git/*" \
        --storage-class STANDARD_IA \
        --no-progress \
        2>&1 | tee -a "$LOG_FILE"

    SYNC_STATUS=${PIPESTATUS[0]}

    if [ $SYNC_STATUS -eq 0 ]; then
        log "SUCCESS: $DIR synced successfully."
        ((SUCCESS_COUNT++))
    else
        log "ERROR: $DIR failed with exit code $SYNC_STATUS."
        ((FAIL_COUNT++))
    fi

done

# --- SUMMARY ---
log "=========================================================="
log "Sync Complete — Success: $SUCCESS_COUNT | Failed: $FAIL_COUNT | Skipped: $SKIP_COUNT"
log "=========================================================="

# Exit with error if any directory failed
[ $FAIL_COUNT -gt 0 ] && exit 1 || exit 0