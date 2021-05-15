#!/bin/bash
source functions/cache.sh

WHOAMI_CACHE="$CACHE_DIR/who-am-i.txt"

function who_am_i_with_cache() {
    RESOLVER_IP=$1

    ensure_cache_file_exists $WHOAMI_CACHE

    MATCHING_LINE=$(grep "^$RESOLVER_IP " <$WHOAMI_CACHE)
    if [[ -n "$MATCHING_LINE" ]]; then
        read R REST <<<$MATCHING_LINE
    else
        read REST <<<$(who_am_i $RESOLVER_IP)

        echo -e "$RESOLVER_IP $REST" >>$WHOAMI_CACHE
    fi

    echo "$REST"
}

function who_am_i() {
    RESOLVER_IP=$1

    DIG_RESPONSE=$(dig +short TXT whoami.ipv4.akahelp.net @$RESOLVER_IP)

    NS=$(awk -F '"' '$2 == "ns"{printf $4}' <<<$DIG_RESPONSE)
    ECS=$(awk -F '"' '$2 == "ecs"{printf $4}' <<<$DIG_RESPONSE)
    IP=$(awk -F '"' '$2 == "ip"{printf $4}' <<<$DIG_RESPONSE)

    echo "$NS $ECS $IP"
}
