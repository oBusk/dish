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
AVERAGE_TIMING=$(echo "scale=1;(${AKAMAI_TIMING:-0} + ${NETFLIX_TIMING:-0} + ${YOUTUBE_TIMING:-0}) / 3" | bc -l)

if [[ "$AVERAGE_TIMING" == "0" ]]; then
    AVERAGE_TIMING=""
fi

echo "; ${AVERAGE_TIMING:}"
