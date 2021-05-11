#!/bin/bash

URL=$1
read -d '' INPUT

function append_result() {
	RESULT="$RESULT
$1"
}

while read -r RESOLVER_IP R || [ -n "$RESOLVER_IP" ]; do
	append_result "$(source httptest.sh $RESOLVER_IP $URL)"
done <<<"$INPUT"

printf "Sep=; $(sort -t ";" -k5 -n <<<$RESULT)"
