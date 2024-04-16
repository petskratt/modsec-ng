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

rewrite_rules() {
    RSRCDIR=$1
    RDSTDIR=$2

    #remove previous rules
    rm "$RDSTDIR/"*berylia.org*.conf

    idx=10000

    cp -p $RSRCDIR/default/*.conf $RDSTDIR/

    for d in $RSRCDIR/*.org; do
        h="${d##*/}"
        #echo $d
        for r in $d/*.conf; do
          rr="${r##*/}"
          #echo $r
          #echo $rr
          sed ':x; /\\$/ { N; s/\\\n//; tx }' $r |   awk -f /convert-rules.awk  -v i=$idx -v h=$h > $RDSTDIR/${h}_${rr}
          n=$(wc -l $RDSTDIR/${h}_${rr} | cut -d " " -f 1)
          #echo $n
          idx=$((idx + n))
          #echo $idx
        done
    done
    return 0
}

copy_and_extract_when_needed() {
    source_hash=`md5sum $1 | awk '{ print $1 }'`
    destination_hash=`md5sum $2 | awk '{ print $1 }'`
#    log "Source_hash: $source_hash"
#    log "Destination_hash $destination_hash"

    if [ "$source_hash" != "$destination_hash" ]; then
        cp $1 $2

        #extract all rules
        pwd_bak=$(pwd)
        rm -r "$DST_DIR/rules"
        cd $DST_DIR &&  tar xf $2 && cd $pwd_bak

        rewrite_rules "$DST_DIR/rules" $RULES_DIR

        log "$2 requires update"
        return 1
    fi

    log "$2 is up to date"
    return 0
}

log "Starting CRS rules syncing from $2 for $1"

DST_DIR="/opt/owasp-crs/ref_rules"
RULES_DIR="/opt/owasp-crs/rules"
BASE_URL="$CRS_RULES_SERVER"

if [ ! -d "$DST_DIR" ]; then
    mkdir -p "$DST_DIR"
fi

# Download rule files
curl -s -o /tmp/rules.tar "$BASE_URL/get_all_rules"

copy_and_extract_when_needed "/tmp/rules.tar" "$DST_DIR/rules.tar"; r1=$?

restart=$r1

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

