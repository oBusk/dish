#!/bin/bash

source functions/who-am-i.sh

RESOLVER_IP=$1

read NS ECS IP <<<$(who_am_i_with_cache $RESOLVER_IP)

echo "$NS; $ECS; $IP"
