#!/bin/bash
source functions/cache.sh

RESOLVE_HOST_CACHE="$CACHE_DIR/resolve-host.txt"

function resolve_host_with_cache() {
    local TARGET_DOMAIN=$1
    local RESOLVER=$2

    ensure_cache_file_exists $RESOLVE_HOST_CACHE

    MATCHING_LINE=$(grep "^$TARGET_DOMAIN $RESOLVER " <$RESOLVE_HOST_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read D R REMOTE_IP <<<$MATCHING_LINE
    else
        REMOTE_IP=$(resolve_host $TARGET_DOMAIN $RESOLVER)
        if [[ -z "$REMOTE_IP" ]]; then
            REMOTE_IP="N/A"
        fi
        echo -e "$TARGET_DOMAIN $RESOLVER $REMOTE_IP" >>$RESOLVE_HOST_CACHE
    fi

    echo $REMOTE_IP
}

function resolve_host() {
    local TARGET_DOMAIN=$1
    local RESOLVER=$2

    if [ -n "$RESOLVER" ]; then
        dig +short $TARGET_DOMAIN @$RESOLVER | tail -n 1
    else
        dig +short $targetdomain | tail -n 1
    fi
}
