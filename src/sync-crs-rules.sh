#!/usr/bin/env sh

log() {
    DATE=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$DATE] [crs-sync] $@"
}

if [ -z "$1" ]; then
    log "Usage: $0 <hostname> <server>"
    exit 1
fi
if [ -z "$2" ]; then
    log "Usage: $0 <hostname> <server>"
    exit 1
fi

FORCE_NO_RESTART=$3

HOSTNAME="$1"
CRS_RULES_SERVER="$2"

copy_when_needed() {
    source_hash=`md5sum $1 | awk '{ print $1 }'`
    destination_hash=`md5sum $2 | awk '{ print $1 }'`
#    log "Source_hash: $source_hash"
#    log "Destination_hash $destination_hash"

    if [ "$source_hash" != "$destination_hash" ]; then
        cp $1 $2

        log "$2 requires update"
        return 1
    fi

    log "$2 is up to date"
    return 0
}

REPO=$1

log "Starting CRS rules syncing from $2 for $1"

RULES_BEFORE="REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf"
RULES_AFTER="RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf"

DST_DIR="/opt/owasp-crs/rules"
BASE_URL="$CRS_RULES_SERVER"

# Download rule files
curl -s -o /tmp/request.conf "$BASE_URL/request?hostname=$HOSTNAME"
curl -s -o /tmp/response.conf "$BASE_URL/response?hostname=$HOSTNAME"

copy_when_needed "/tmp/request.conf" "$DST_DIR/$RULES_BEFORE"; r1=$?
copy_when_needed "/tmp/response.conf" "$DST_DIR/$RULES_AFTER"; r2=$?

restart=$r1 || $r2

if [ $FORCE_NO_RESTART -eq 1 ]; then
    log "Forcing no restart flag!"
    restart=0
fi

response=`nginx -t 2>&1`
if [ $? -ne 0 ]; then 
    curl -s -o /dev/null "$BASE_URL/report_error?hostname=$HOSTNAME" --data "$response"
fi

if [ $restart -eq 1 ]; then
    # test nginx config and reload
    nginx -t && nginx -s reload
    if [ $? -eq 0 ]; then
        log "CRS rules synced successfully from ${1} on branch ${2}"
    else
        log "CRS rules sync failed"
        exit 1
    fi
fi

