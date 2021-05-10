#!/bin/bash
source functions

# THE PLAN:
# Use each resolver to get what IP they point to
# Loop over each IP to see pre-transfer timings
# Re-attach result of each IP to resolver

URL=$1
read -d '' INPUT

read EFFECTIVE_URL PORT <<<$(get_effective_url_and_port $URL)
EFFECTIVE_HOST=$(get_host $EFFECTIVE_URL)

# A registry of all the remote IPs followed by the resolvers that found that particual IP
REMOTE_IPS=""
while IFS= read -r RESOLVER_IP || [ -n "$RESOLVER_IP" ]; do
	REMOTE_IP=$(resolve_host_with_cache $EFFECTIVE_HOST $RESOLVER_IP)

	if [[ ! "$REMOTE_IPS" == *"$REMOTE_IP"* ]]; then
		# Create new line for this ip with only this resolver
		REMOTE_IPS="$REMOTE_IPS $REMOTE_IP
"
	fi
done <<<"$INPUT"

# Remove last line
REMOTE_IPS=$(head -n -1 <<<"$REMOTE_IPS")

while read -r REMOTE_IP REST || [ -n "$REMOTE_IP" ]; do
	DISTANCE=$(count_hops_with_cache $REMOTE_IP)
	LOCATION=$(ip_location_with_cache $REMOTE_IP)
	TIME_PRETRANSFER=$(time_pretransfer $REMOTE_IP $EFFECTIVE_HOST $PORT $EFFECTIVE_URL)

	REMOTE_IPS=$(sed "/${REMOTE_IP}/ s/$/ ${LOCATION} ${DISTANCE} $(s_to_ms $TIME_PRETRANSFER)/" <<<$REMOTE_IPS)

	echo "[$REMOTE_IP] Location: $LOCATION, Distance: $DISTANCE, Pre-transfer: $(s_to_ms $TIME_PRETRANSFER)"
done <<<"$REMOTE_IPS"

# echo -e $REMOTE_IPS
