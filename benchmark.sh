#!/bin/bash

RESOLVER_IP=$1

echo "$RESOLVER_IP; $(source benchmarks/dns-location.sh $RESOLVER_IP); $(source benchmarks/dnsping.sh $RESOLVER_IP); $(source benchmarks/cdn.sh $RESOLVER_IP)"
