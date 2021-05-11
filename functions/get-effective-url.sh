#!/bin/bash
source functions/cache.sh

EFFECTIVE_URL_CACHE="$CACHE_DIR/effective-url.txt"

function get_effective_url_and_port_with_cache {
    local URL=$1

    ensure_cache_file_exists $EFFECTIVE_URL_CACHE

    MATCHING_LINE=$(grep "^$URL" <$EFFECTIVE_URL_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read U EFFECTIVE_HOST EFFECTIVE_URL PORT <<<$MATCHING_LINE
    else
        read EFFECTIVE_HOST EFFECTIVE_URL PORT <<<$(get_effective_url_and_port $URL)

        echo -e "$URL $EFFECTIVE_HOST $EFFECTIVE_URL $PORT" >>$EFFECTIVE_URL_CACHE
    fi

    echo "$EFFECTIVE_HOST $EFFECTIVE_URL $PORT"
}

# Follows url ($1) redirects and returns the "effective url", the resulting URL
# after following all redirects.
function get_effective_url_and_port() {
    read EFFECTIVE_URL PORT <<<$(curl \
        -I \
        -s \
        -o /dev/null \
        -L \
        -w '%{url_effective} %{remote_port}' \
        $1)

    EFFECTIVE_HOST=$(get_host $EFFECTIVE_URL)

    echo "$EFFECTIVE_HOST $EFFECTIVE_URL $PORT"
}

# Takes a url ($1) and returns the hostname of that URL
function get_host() {
    echo "$1" | sed -e 's|^[^/]*//||' -e 's|/.*$||'
}
