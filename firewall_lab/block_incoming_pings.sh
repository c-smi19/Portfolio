#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to close block incoming pings.

# Block incoming pings
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Let the user know the process is complete
echo "Incoming pings are now: BLOCKED"
