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
	REMOTE_IP=$(resolve_host $EFFECTIVE_HOST $RESOLVER_IP)

	if [[ "$REMOTE_IPS" == *"$REMOTE_IP"* ]]; then
		# Add the current resolver to this ip
		REMOTE_IPS=$(sed "/${REMOTE_IP}/ s/$/,${RESOLVER_IP}/" <<<$REMOTE_IPS)
	else
		# Create new line for this ip with only this resolver
		REMOTE_IPS="$REMOTE_IPS $REMOTE_IP $RESOLVER_IP
"
	fi
done <<<"$INPUT"

# Remove last line
REMOTE_IPS=$(head -n -1 <<<"$REMOTE_IPS")

# readarray -t LINES <<<"$REMOTE_IPS"

while read -r REMOTE_IP RESOLVERS REST || [ -n "$REMOTE_IP" ]; do
	DISTANCE=$(count_hops $REMOTE_IP)
	LOCATION=$(ip_location $REMOTE_IP)
	TIME_PRETRANSFER=$(curl \
		-w '%{time_pretransfer}' \
		-I \
		-s \
		-o /dev/null \
		--resolve "$EFFECTIVE_HOST:$PORT:$REMOTE_IP" \
		$EFFECTIVE_URL)

	REMOTE_IPS=$(sed "/${REMOTE_IP}/ s/$/ ${LOCATION} ${DISTANCE} $(s_to_ms $TIME_PRETRANSFER)/" <<<$REMOTE_IPS)

	echo "[$REMOTE_IP]($RESOLVERS) Location: $LOCATION, Distance: $DISTANCE, Pre-transfer: $(s_to_ms $TIME_PRETRANSFER)"
done <<<"$REMOTE_IPS"

# echo -e $REMOTE_IPS
