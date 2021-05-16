#!/bin/bash
source functions/cache.sh

ip_info_CACHE="$CACHE_DIR/ip-info.txt"

function ip_info_with_cache() {
	local REMOTE_IP=$1

	ensure_cache_file_exists $ip_info_CACHE

	MATCHING_LINE=$(grep "^$REMOTE_IP\\t" <$ip_info_CACHE)
	if [[ -n "$MATCHING_LINE" ]]; then
		IFS=$'\t' read -r R HOSTNAME ORGANIZATION LOCATION <<<$MATCHING_LINE
	else
		IFS=$'\t' read -r HOSTNAME ORGANIZATION LOCATION <<<$(ip_info $REMOTE_IP)

		echo -e "$REMOTE_IP	$HOSTNAME	$ORGANIZATION	$LOCATION" >>$ip_info_CACHE
	fi

	echo -e "$HOSTNAME	$ORGANIZATION	$LOCATION"
}

function ip_info() {
	curl -s ipinfo.io/$1 | jq -j '.hostname, "	", .org, "	", .city, ", ", .country'
}
