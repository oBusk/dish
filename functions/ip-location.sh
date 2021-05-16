#!/bin/bash
source functions/cache.sh

IP_LOCATION_CACHE="$CACHE_DIR/ip-location.txt"

function ip_location_with_cache() {
	local REMOTE_IP=$1

	ensure_cache_file_exists $IP_LOCATION_CACHE

	MATCHING_LINE=$(grep "^$REMOTE_IP\\t" <$IP_LOCATION_CACHE)
	if [[ -n "$MATCHING_LINE" ]]; then
		IFS=$'\t' read -r R HOSTNAME ORGANIZATION LOCATION <<<$MATCHING_LINE
	else
		IFS=$'\t' read -r HOSTNAME ORGANIZATION LOCATION <<<$(ip_location $REMOTE_IP)

		echo -e "$REMOTE_IP	$HOSTNAME	$ORGANIZATION	$LOCATION" >>$IP_LOCATION_CACHE
	fi

	echo -e "$HOSTNAME	$ORGANIZATION	$LOCATION"
}

function ip_location() {
	curl -s ipinfo.io/$1 | jq -j '.hostname, "	", .org, "	", .city, ", ", .country'
}
