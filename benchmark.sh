#!/bin/bash
source functions/organization.sh

RESOLVER_IP=$1

echo "$RESOLVER_IP; $(organization_with_cache $RESOLVER_IP); $(source benchmarks/dns-location.sh $RESOLVER_IP); $(source benchmarks/cdn.sh $RESOLVER_IP)"
