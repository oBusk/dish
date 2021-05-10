#!/bin/bash
source functions/cache.sh

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
