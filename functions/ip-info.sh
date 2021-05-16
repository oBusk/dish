#!/bin/bash
source functions/cache.sh

IP_INFO_CACHE="$CACHE_DIR/ip-info.csv"

function ip_info_with_cache() {
	local REMOTE_IP=$1

	ensure_cache_csv_exists $IP_INFO_CACHE

	MATCHING_LINE=$(grep "^$REMOTE_IP;" <$IP_INFO_CACHE)
	if [[ -n "$MATCHING_LINE" ]]; then
		IFS=';' read -r R REMOTE_HOSTNAME ORGANIZATION LOCATION <<<$MATCHING_LINE
	else
		IFS=';' read -r REMOTE_HOSTNAME ORGANIZATION LOCATION <<<$(ip_info $REMOTE_IP)

		echo -e "$REMOTE_IP;$REMOTE_HOSTNAME;$ORGANIZATION;$LOCATION" >>$IP_INFO_CACHE
	fi

	echo -e "$REMOTE_HOSTNAME;$ORGANIZATION;$LOCATION"
}

function ip_info() {
	# curl -s ipinfo.io/$1 | jq -j '.hostname, ";", .org, ";", .city, ", ", .country'
	curl -s "http://ip-api.com/json/$1?fields=countryCode,city,org,reverse" | jq -j '.reverse, ";", .org, ";", .city, ", ", .countryCode'
}
