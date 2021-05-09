#!/bin/bash
source functions

resolver_ips=$1
url=$2

effective_url=$(get_effective_url $url)

echo 'Effective URL:' $effective_url

# https://www.interserver.net/tips/kb/how-to-test-website-response-time-in-linux-terminal/

curl -w '
Remote IP:		%{remote_ip}

Lookup Time:		%{time_namelookup}
Connect Time:		%{time_connect}
AppCon Time:		%{time_appconnect}
Pre-transfer Time:	%{time_pretransfer}
Start-transfer Time:	%{time_starttransfer}

Total Time:		%{time_total}
' \
	--max-filesize 1 \
	-I \
	-s \
	-o /dev/null \
	--dns-servers $resolver_ips \
	$effective_url
