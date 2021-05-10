#!/bin/bash

source functions/cache.sh

RESOLVE_HOST_CACHE="$CACHE_DIR/resolve_host.txt"
COUNT_HOPS_CACHE="$CACHE_DIR/count_hops.txt"
IP_LOCATION_CACHE="$CACHE_DIR/ip-location.txt"
TIME_PRETRANSFER_CACHE="$CACHE_DIR/time-pretransfer.txt"

function resolve_host_with_cache() {
    local TARGET_DOMAIN=$1
    local RESOLVER=$2

    ensure_cache_file_exists $RESOLVE_HOST_CACHE

    MATCHING_LINE=$(grep "^$TARGET_DOMAIN $RESOLVER" <$RESOLVE_HOST_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read D R REMOTE_IP <<<$MATCHING_LINE
    else
        REMOTE_IP=$(resolve_host $TARGET_DOMAIN $RESOLVER)
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

# Follows url ($1) redirects and returns the "effective url", the resulting URL
# after following all redirects.
function get_effective_url_and_port() {
    curl \
        -I \
        -s \
        -o /dev/null \
        -L \
        -w '%{url_effective} ${remote_port}' \
        $1
}

# Takes seconds and outputs it as ms with a single decimal place
function s_to_ms() {
    echo "$(echo "scale=1;${1}*1000/1" | bc)ms"
}

# Escapes all forward slashes so that we can find/replace urls with sed command
function sed_escape() {
    echo ${1} | sed -e "s#/#\\\/#g"
}

# Takes a url ($1) and returns the hostname of that URL
function get_host() {
    echo "$1" | sed -e 's|^[^/]*//||' -e 's|/.*$||'
}

function count_hops_with_cache() {
    local REMOTE_IP=$1

    ensure_cache_file_exists $COUNT_HOPS_CACHE

    MATCHING_LINE=$(grep "^$REMOTE_IP" <$COUNT_HOPS_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read R NUMBER_OF_HOPS <<<$MATCHING_LINE
    else
        NUMBER_OF_HOPS=$(count_hops $REMOTE_IP)

        echo -e "$REMOTE_IP $NUMBER_OF_HOPS" >>$COUNT_HOPS_CACHE
    fi

    echo $NUMBER_OF_HOPS
}

function count_hops() {
    mtr -n -r -c 1 $1 | grep -Po '^\s*\d+' | tail -n 1 | xargs
}

function ip_location_with_cache() {
    local REMOTE_IP=$1

    ensure_cache_file_exists $IP_LOCATION_CACHE

    MATCHING_LINE=$(grep "^$REMOTE_IP" <$IP_LOCATION_CACHE)
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

function time_pretransfer_x_with_cache() {
    local REMOTE_IP=$1
    local HOST=$2
    local PORT=$3
    local URL=$4

    ensure_cache_file_exists $TIME_PRETRANSFER_CACHE

    MATCHING_LINE=$(grep "^$REMOTE_IP $HOST $PORT $URL" <$TIME_PRETRANSFER_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read R H P U TIME_PRETRANSFER <<<$MATCHING_LINE
    else
        TIME_PRETRANSFER=$(time_pretransfer_x $REMOTE_IP $HOST $PORT $URL)
        echo -e "$REMOTE_IP $HOST $PORT $URL $TIME_PRETRANSFER" >>$TIME_PRETRANSFER_CACHE
    fi

    echo $TIME_PRETRANSFER
}

function time_pretransfer_x {
    local REMOTE_IP=$1
    local HOST=$2
    local PORT=$3
    local URL=$4

    local SUM=0
    for i in {1..10}; do
        local TIME_PRETRANSFER=$(time_pretransfer $REMOTE_IP $HOST $PORT $URL)

        local SUM=$(echo "$SUM + $TIME_PRETRANSFER" | bc -l)
    done

    echo "$SUM / 10" | bc -l
}

function time_pretransfer() {
    local REMOTE_IP=$1
    local HOST=$2
    local PORT=$3
    local URL=$4

    curl \
        -w '%{time_pretransfer}' \
        -I \
        -s \
        -o /dev/null \
        --resolve "$EFFECTIVE_HOST:$PORT:$REMOTE_IP" \
        $EFFECTIVE_URL
}
