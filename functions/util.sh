#!/bin/bash

source functions/cache.sh

TIME_PRETRANSFER_CACHE="$CACHE_DIR/time-pretransfer.txt"

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
