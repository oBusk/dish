source functions/cache.sh

COUNT_HOPS_CACHE="$CACHE_DIR/count-hops.txt"

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
