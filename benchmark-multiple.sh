#!/bin/bash

# Run all tests on multiple resolvers (std. input) and output it (std. output)

read -d '' INPUT

# function append_line() {
# 	RESULT="$RESULT
# $1"
# }

echo "Sep=;"
echo "DNS Ip; hostname; DNS Organization; whoami 'ns'; ns location; ns distance; whoami 'ecs'; whoami 'ip'; Akamai Edge; Akamai Edge Location; Akamai Edge Distance; Akamai Edge Pretransfer; Netflix Edge; Netflix Edge Location; Netflix Edge Distance; Netflix Edge Pretransfer; Youtube Edge; Youtube Edge Location; Youtube Edge Distance; Youtube Edge Pretransfer"

while read -r RESOLVER_IP R || [ -n "$RESOLVER_IP" ]; do
	#append_line "$(source benchmark.sh $RESOLVER_IP)"
	echo "$(source benchmark.sh $RESOLVER_IP)"
done <<<"$INPUT"

# echo "$(sort -t ";" -k11 -n <<<$RESULT)"
