#!/bin/bash
source functions

# THE PLAN:
# Use each resolver to get what IP they point to
# Loop over each IP to see pre-transfer timings
# Re-attach result of each IP to resolver

URL=$1
read -d '' INPUT

# Uses Resolver IP ($1) to lookup and follow redirects to get
#
# * Effective URL
#  and
# * Remote IP
#
# Most cases I've tested will only have redirects/CNAME that leads us to the
# same domain, but just in case there are any differances, we at least take
# account for it.
function resolve() {
	local RESOLVER_IP=$1
	local URL=$2

	CURLOPT_DNS_CACHE_TIMEOUT=0 curl \
		-I \
		-s \
		-o /dev/null \
		-L \
		-w '%{remote_ip} %{url_effective}' \
		--dns-servers 127.0.0.1 \
		$URL
}

RESULTS=""

# Escapes all forward slashes so that we can find/replace urls with sed command
sed_escape() {
	echo ${1} | sed -e "s#/#\\\/#g"
}

while IFS= read -r RESOLVER_IP || [ -n "${RESOLVER_IP}" ]; do
	read -r REMOTE_IP EFFECTIVE_URL \
		<<<$(resolve $RESOLVER_IP $URL)

	if [[ "$RESULTS" == *"$REMOTE_IP $EFFECTIVE_URL"* ]]; then
		# Add the current resolver to this ip/effective_url
		RESULTS=$(sed "/${REMOTE_IP} $(sed_escape $EFFECTIVE_URL)/ s/$/,${RESOLVER_IP}/" <<<$RESULTS)
	else
		# Create new line for this ip/effective_url with only this resolver
		RESULTS="${RESULTS}\n${REMOTE_IP} ${EFFECTIVE_URL} ${RESOLVER_IP}"
	fi
done <<<$INPUT

echo -e $RESULTS
