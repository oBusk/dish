#!/bin/bash
source functions/util.sh
source functions/effective-url.sh
source functions/resolve-host.sh
source functions/count-hops.sh
source functions/ip-info.sh
source functions/time-pretransfer.sh

RESOLVER_IP=$1
URL=$2

read EFFECTIVE_HOST EFFECTIVE_URL PORT <<<$(effective_url_and_port_with_cache $URL)

REMOTE_IP=$(resolve_host_with_cache $EFFECTIVE_HOST $RESOLVER_IP)

if [[ "$REMOTE_IP" != "N/A" ]]; then
    DISTANCE=$(count_hops_with_cache $REMOTE_IP true)
    IFS=';' read -r REMOTE_HOSTNAME ORGANIZATION LOCATION <<<$(ip_info_with_cache $REMOTE_IP)
    TIME_PRETRANSFER=$(s_to_ms $(time_pretransfer_x_with_cache $REMOTE_IP $EFFECTIVE_HOST $PORT $EFFECTIVE_URL))
fi

echo "$REMOTE_IP; $REMOTE_HOSTNAME; $LOCATION; $DISTANCE; $TIME_PRETRANSFER"
