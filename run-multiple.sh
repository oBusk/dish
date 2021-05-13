#!/bin/bash

# Run all tests on multiple resolvers (std. input) and output it (std. output)

read -d '' INPUT

function append_line() {
	RESULT="$RESULT
$1"
}

function continue_line() {
	RESULT="$RESULT $1"
}

while read -r RESOLVER_IP R || [ -n "$RESOLVER_IP" ]; do
	append_line "$RESOLVER_IP; "
	continue_line "$(source dns-location-test.sh $RESOLVER_IP)"
	continue_line "$(source cdn-test.sh $RESOLVER_IP)"
done <<<"$INPUT"

printf "Sep=; $(sort -t ";" -k5 -n <<<$RESULT)
"
