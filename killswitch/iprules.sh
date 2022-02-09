#!/bin/bash

iptables-restore < /tmp/killswitch/ipv4
ip6tables-restore < /tmp/killswitch/ipv6
