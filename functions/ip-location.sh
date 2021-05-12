#!/bin/bash
source functions/cache.sh

IP_LOCATION_CACHE="$CACHE_DIR/ip-location.txt"

function ip_location_with_cache() {
    local REMOTE_IP=$1

    ensure_cache_file_exists $IP_LOCATION_CACHE

    MATCHING_LINE=$(grep "^$REMOTE_IP " <$IP_LOCATION_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read R IP_LOCATION <<<$MATCHING_LINE
    else
        IP_LOCATION=$(ip_location $REMOTE_IP)

        echo -e "$REMOTE_IP $IP_LOCATION" >>$IP_LOCATION_CACHE
    fi

    echo $IP_LOCATION
}

function ip_location() {
    curl -s ipinfo.io/$1 | jq -j '.city, ", ", .country'
}
