#!/bin/bash

# Test the ability of resolver ($1) to find nearby edge nodes

RESOLVER_IP=$1

source benchmarks/url.sh \
    $RESOLVER_IP \
    https://www.akamai.com/
