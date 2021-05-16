#!/bin/bash
source functions/who-am-i.sh
source functions/ip-info.sh
source functions/count-hops.sh

RESOLVER_IP=$1

IFS=';' read -r NS_HOSTNAME NS_ORGANIZATION NS_LOCATION <<<$(ip_info_with_cache $RESOLVER_IP)
read NS ECS IP <<<$(who_am_i_with_cache $RESOLVER_IP)

if [[ -n "$NS" ]]; then
    IFS=';' read -r WHOAMI_HOSTNAME WHOAMI_ORGANIZATION WHOAMI_LOCATION <<<$(ip_info_with_cache $NS)
    NS_DISTANCE=$(count_hops_with_cache $NS)
fi

echo "$NS_HOSTNAME; $NS_ORGANIZATION; $NS; $WHOAMI_LOCATION; $NS_DISTANCE; $ECS; $IP"
