#!/usr/bin/env sh

if [ -z "$1" ]; then
    log "Usage: $0 <repo>"
    exit 1
fi
# If no branch is specified, use main
if [ -z "$2" ]; then
    BRANCH="main"
else
    BRANCH=$2
fi

log() {
    DATE=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$DATE] [crs-sync] $@"
}

REPO=$1

log "Starting CRS rules syncing from ${1} on branch ${2}"

RULES_BEFORE="REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf"
RULES_AFTER="RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf"

DST_DIR="/opt/owasp-crs/rules"
BASE_URL="https://raw.githubusercontent.com"

# Download rule files
curl -s -o $DST_DIR/$RULES_BEFORE $BASE_URL/$REPO/$BRANCH/src/rules/$RULES_BEFORE
curl -s -o $DST_DIR/$RULES_AFTER $BASE_URL/$REPO/$BRANCH/src/rules/$RULES_AFTER

# test nginx config and reload
nginx -t && nginx -s reload
if [ $? -eq 0 ]; then
    log "CRS rules synced successfully from ${1} on branch ${2}"
else
    log "CRS rules sync failed"
    exit 1
fi