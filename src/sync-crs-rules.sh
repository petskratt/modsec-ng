#!/usr/bin/env sh

REPO=$1
RULES_BEFORE="REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf"
RULES_AFTER="REQUEST-901-EXCLUSION-RULES-AFTER-CRS.conf"

DST_DIR="/opt/owasp-crs/rules"
BASE_URL="https://raw.githubusercontent.com"

if [ -z "$REPO" ]; then
    echo "Usage: $0 <repo>"
    exit 1
fi

# Download the rules
curl -o $DST_DIR/$RULES_BEFORE $BASE_URL/$REPO/master/rules/$RULES_BEFORE
curl -o $DST_DIR/$RULES_AFTER $BASE_URL/$REPO/master/rules/$RULES_AFTER

# test if nginx config is working, if so, reload nginx
nginx -t && nginx -s reload