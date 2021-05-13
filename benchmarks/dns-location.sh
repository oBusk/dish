#!/bin/bash
source functions/who-am-i.sh
source functions/ip-location.sh
source functions/count-hops.sh

RESOLVER_IP=$1

read NS ECS IP <<<$(who_am_i_with_cache $RESOLVER_IP)

if [[ -n "$NS" ]]; then
    NS_LOCATION=$(ip_location_with_cache $NS)
    NS_DISTANCE=$(count_hops_with_cache $NS)
fi

echo "$NS; $NS_LOCATION; $NS_DISTANCE; $ECS; $IP"
