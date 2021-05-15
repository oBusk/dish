#!/bin/bash
source functions/cache.sh

COUNT_HOPS_CACHE="$CACHE_DIR/count-hops.txt"

function count_hops_with_cache() {
    local REMOTE_IP=$1
    local HTTPS="${2:-false}"

    ensure_cache_file_exists $COUNT_HOPS_CACHE

    MATCHING_LINE=$(grep "^$REMOTE_IP $HTTPS " <$COUNT_HOPS_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read REMOTE_IP HTTPS NUMBER_OF_HOPS <<<$MATCHING_LINE
    else
        NUMBER_OF_HOPS=$(count_hops $REMOTE_IP $HTTPS)

        echo -e "$REMOTE_IP $HTTPS $NUMBER_OF_HOPS" >>$COUNT_HOPS_CACHE
    fi

    echo $NUMBER_OF_HOPS
}

function count_hops() {
    local REMOTE_IP=$1
    local HTTPS=$2

    if [ "$HTTPS" = true ]; then
        mtr -n -r -c 1 -U 99 -m 99 -T -P 443 $1 |
            awk -F '\\.\\|\\-\\-' '$1 ~ /[0-9]+/{a=$1; b=$2} END{ if (b ~ /\?\?\?/) { print "???" } else { gsub(/^ +| +$/, "", a); print a } }'
    else
        mtr -n -r -c 1 -U 99 -m 99 $1 |
            awk -F '\\.\\|\\-\\-' '$1 ~ /[0-9]+/{a=$1; b=$2} END{ if (b ~ /\?\?\?/) { print "???" } else { gsub(/^ +| +$/, "", a); print a } }'
    fi
}
