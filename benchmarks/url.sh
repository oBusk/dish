#!/bin/bash
source functions/util.sh
source functions/effective-url.sh
source functions/resolve-host.sh
source functions/count-hops.sh
source functions/ip-location.sh
source functions/time-pretransfer.sh

RESOLVER_IP=$1
URL=$2

read EFFECTIVE_HOST EFFECTIVE_URL PORT <<<$(effective_url_and_port_with_cache $URL)

REMOTE_IP=$(resolve_host_with_cache $EFFECTIVE_HOST $RESOLVER_IP)

if [[ "$REMOTE_IP" == "N/A" ]]; then
    echo $RESOLVER_IP
else
    DISTANCE=$(count_hops_with_cache $REMOTE_IP)
    LOCATION=$(ip_location_with_cache $REMOTE_IP)
    TIME_PRETRANSFER=$(time_pretransfer_x_with_cache $REMOTE_IP $EFFECTIVE_HOST $PORT $EFFECTIVE_URL)

    echo "$REMOTE_IP; $LOCATION; $DISTANCE; $(s_to_ms $TIME_PRETRANSFER)"
fi
