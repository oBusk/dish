#!/bin/bash

. functions

resolver=$1
targetdomain=$2

# Resolve IP of target using resolver
resolved_ip=$(resolve_host $targetdomain $resolver)
echo -e "resolved ip:\t" $resolved_ip
echo -n "="

# Count number of jumps to IP of target
distance=$(mtr -nr $resolved_ip | grep -Po '^\s*\d+' | tail -n 1 | xargs)
# echo -e "distance:\t" $distance
echo -n "="

# Ping resolved ip
avg_ping=$(ping -c 5 $resolved_ip | grep -Po '(?<=\/)\d+(\.\d+)?(?=\/)' | head -n 1)
# echo -e "average ping:\t" $avg_ping
echo -ne "=\n"

echo -e "resolv. Ip\tDist.\tPing"
echo -e $resolved_ip "\t" $distance "\t" $avg_ping
