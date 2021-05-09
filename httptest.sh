#!/bin/bash
source functions

resolver_ips=$1
url=$2

effective_url=$(get_effective_url $url)

echo 'Effective URL:' $effective_url

# https://www.interserver.net/tips/kb/how-to-test-website-response-time-in-linux-terminal/

read -r remote_ip time_namelookup time_pretransfer \
	<<<$(curl -w '%{remote_ip} %{time_namelookup} %{time_pretransfer}' \
		--max-filesize 1 \
		-I \
		-s \
		-o /dev/null \
		--dns-servers $resolver_ips \
		$effective_url)

echo $remote_ip "	" $time_namelookup "	" $time_pretransfer
