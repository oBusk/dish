#!/bin/bash

resolver=$1
targetdomain=$2

# Resolve IP of target using resolver
resolvedIp=$(dig +short $targetdomain @$resolver | tail -n 1)
# echo -e "resolved ip:\t" $resolvedIp
echo -n "="

# Count number of jumps to IP of target
distance=$(mtr -nr $resolvedIp | grep -Po '^\s*\d+' | tail -n 1 | xargs)
# echo -e "distance:\t" $distance
echo -n "="

# Ping resolved ip
avgPing=$(ping -c 5 $resolvedIp | grep -Po '(?<=\/)\d+(\.\d+)?(?=\/)' | head -n 1)
# echo -e "average ping:\t" $avgPing
echo -ne "=\n"

echo -e "resolv. Ip\tDist.\tPing"
echo -e $resolvedIp "\t" $distance "\t" $avgPing
