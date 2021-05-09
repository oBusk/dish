#!/bin/bash
source functions

# THE PLAN:
# Use each resolver to get what IP they point to
# Loop over each IP to see pre-transfer timings
# Re-attach result of each IP to resolver

URL=$1
read -d '' INPUT

EFFECTIVE_URL=$(get_effective_url $URL)
EFFECTIVE_HOST=$(get_host $EFFECTIVE_URL)

# A registry of all the remote IPs followed by the resolvers that found that particual IP
RESULTS=""
while IFS= read -r RESOLVER_IP || [ -n "${RESOLVER_IP}" ]; do
	REMOTE_IP=$(resolve_host $EFFECTIVE_HOST $RESOLVER_IP)

	if [[ "$RESULTS" == *"$REMOTE_IP"* ]]; then
		# Add the current resolver to this ip
		RESULTS=$(sed "/${REMOTE_IP}/ s/$/,${RESOLVER_IP}/" <<<$RESULTS)
	else
		# Create new line for this ip with only this resolver
		RESULTS="${RESULTS}\n${REMOTE_IP} ${RESOLVER_IP}"
	fi
done <<<$INPUT

echo -e $RESULTS
