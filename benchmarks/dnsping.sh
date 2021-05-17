#!/bin/bash
source functions/dnsping.sh

RESOLVER_IP=$1

dnsping_with_cache $RESOLVER_IP
