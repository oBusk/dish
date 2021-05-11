#!/bin/bash
source functions/cache.sh

# Takes seconds and outputs it as ms with a single decimal place
function s_to_ms() {
    echo "$(echo "scale=1;${1}*1000/1" | bc)ms"
}

# Escapes all forward slashes so that we can find/replace urls with sed command
function sed_escape() {
    echo ${1} | sed -e "s#/#\\\/#g"
}
