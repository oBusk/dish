#!/bin/bash

# Run all tests on multiple resolvers (std. input) and output it (std. output)

read -d '' INPUT

function append_line() {
	echo "$RESULT
$1"
}

while read -r RESOLVER_IP R || [ -n "$RESOLVER_IP" ]; do
	append_line "$(
		source cdn-test.sh $RESOLVER_IP https://www.akamai.com/us/en/multimedia/images/logo/akamai-logo.png
	)"
done <<<"$INPUT"

printf "Sep=; $(sort -t ";" -k5 -n <<<$RESULT)"
