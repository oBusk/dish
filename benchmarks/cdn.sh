#!/bin/bash

# Test the ability of resolver ($1) to find nearby edge nodes

RESOLVER_IP=$1

AKAMAI_RESULT="$(source benchmarks/url.sh $RESOLVER_IP https://www.akamai.com)"
AKAMAI_TIMING=$(echo $AKAMAI_RESULT | cut -d ';' -f 5-)
echo -n "$AKAMAI_RESULT"
NETFLIX_RESULT="$(source benchmarks/url.sh $RESOLVER_IP https://netflix.com)"
NETFLIX_TIMING=$(echo $NETFLIX_RESULT | cut -d ';' -f 5-)
echo -n "; $NETFLIX_RESULT"
YOUTUBE_RESULT="$(source benchmarks/url.sh $RESOLVER_IP https://youtube.com)"
YOUTUBE_TIMING=$(echo $YOUTUBE_RESULT | cut -d ';' -f 5-)
echo -n "; $YOUTUBE_RESULT"
echo "; " $(echo "scale=1;($AKAMAI_TIMING + $NETFLIX_TIMING + $YOUTUBE_TIMING) / 3" | bc -l)
