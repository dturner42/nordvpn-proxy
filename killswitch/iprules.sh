#!/bin/bash
echo "####### Installing killswitch #######"
iptables-restore < /tmp/killswitch/ipv4
set +e
ip6tables-restore < /tmp/killswitch/ipv6
set -e
