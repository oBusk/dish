#!/bin/bash
source functions/fetch-dnsdiag.sh

sudo apt-get update
sudo apt-get install jq parallel
fetch_dnsdiag
