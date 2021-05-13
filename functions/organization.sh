#!/bin/bash
source functions/cache.sh

ORGANIZATION_CACHE="$CACHE_DIR/organization.txt"

function organization_with_cache() {
    REMOTE_IP=$1

    ensure_cache_file_exists $ORGANIZATION_CACHE

    MATCHING_LINE=$(grep "^$REMOTE_IP " <$ORGANIZATION_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read R ORGANIZATION <<<$MATCHING_LINE
    else
        ORGANIZATION=$(organization $REMOTE_IP)

        echo -e "$REMOTE_IP $ORGANIZATION" >>$ORGANIZATION_CACHE
    fi

    echo $ORGANIZATION
}

function organization() {
    REMOTE_IP=$1

    awk -F ':' '$1 == "Organization"{a=$2} END{gsub(/^ +| +$/, "", a);print a}' <<<$(whois $REMOTE_IP)
}
