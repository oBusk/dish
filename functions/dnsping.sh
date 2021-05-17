#!/bin/bash
source functions/cache.sh

DNSPING_CACHE="$CACHE_DIR/dnsping.txt"

function dnsping_with_cache() {
    local REMOTE_IP=$1
    local DOMAIN=${2:-google.com}

    ensure_cache_file_exists $DNSPING_CACHE

    MATCHING_LINE=$(grep "^$REMOTE_IP $DOMAIN " <$DNSPING_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read REMOTE_IP DOMAIN DNSPING <<<$MATCHING_LINE
    else
        DNSPING=$(dnsping $REMOTE_IP)

        echo -e "$REMOTE_IP $DOMAIN $DNSPING" >>$DNSPING_CACHE
    fi

    [[ "$DNSPING" == "0.000" ]] && echo "9999" || echo "$DNSPING"
}

function dnsping() {
    .dnsdiag/dnsping -q -s $RESOLVER_IP google.com | grep -Po "(?<=avg\=)[\d\.]+(?= ms)"
}
