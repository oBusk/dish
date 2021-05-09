#!/bin/bash
source functions

URL=$1
read -d '' INPUT

EFFECTIVE_URL=$(get_effective_url $URL)

echo 'Effective URL:' $EFFECTIVE_URL

while IFS= read -r RESOLVER_IP || [ -n "${RESOLVER_IP}" ]; do
	read -r REMOTE_IP TIME_NAMELOOKUP TIME_PRETRANSFER \
		<<<$(bash httptest.sh $RESOLVER_IP $URL)

	echo $RESOLVER_IP "	" $REMOTE_IP "	" $TIME_NAMELOOKUP "	" $TIME_PRETRANSFER
done <<<$INPUT
