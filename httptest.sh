#!/bin/bash
source functions

resolver_ips=$1
effective_url=$2

# https://www.interserver.net/tips/kb/how-to-test-website-response-time-in-linux-terminal/

read -r remote_ip time_namelookup time_pretransfer \
	<<<$(curl -w '%{remote_ip} %{time_namelookup} %{time_pretransfer}' \
		--max-filesize 1 \
		-I \
		-s \
		-o /dev/null \
		--dns-servers $resolver_ips \
		$effective_url)

echo $remote_ip " " $time_namelookup " " $time_pretransfer
