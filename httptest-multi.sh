#!/bin/bash
source functions/util.sh
source functions/resolve-host.sh
source functions/count-hops.sh
source functions/ip-location.sh
source functions/time-pretransfer.sh

URL=$1
read -d '' INPUT

read EFFECTIVE_URL PORT <<<$(get_effective_url_and_port $URL)
EFFECTIVE_HOST=$(get_host $EFFECTIVE_URL)

function append_result() {
	RESULT="$RESULT
$1"
}

while read -r RESOLVER_IP R || [ -n "$RESOLVER_IP" ]; do
	REMOTE_IP=$(resolve_host_with_cache $EFFECTIVE_HOST $RESOLVER_IP)

	if [[ "$REMOTE_IP" == "N/A" ]]; then
		append_result $RESOLVER_IP
	else
		DISTANCE=$(count_hops_with_cache $REMOTE_IP)
		LOCATION=$(ip_location_with_cache $REMOTE_IP)
		TIME_PRETRANSFER=$(time_pretransfer_x_with_cache $REMOTE_IP $EFFECTIVE_HOST $PORT $EFFECTIVE_URL)

		append_result "$RESOLVER_IP; $REMOTE_IP; $LOCATION; $DISTANCE; $(s_to_ms $TIME_PRETRANSFER)"
	fi
done <<<"$INPUT"

RESULT=$(printf "$RESULT" | sort -t ";" -k5 -n <<<$RESULT)

printf "Sep=; $RESULT"
