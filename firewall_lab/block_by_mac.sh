#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to block incoming traffic from a user specified MAC address.

# Get the MAC address from the user.
echo "Enter the MAC address you want to block"
read -r mac_addr

# Block incoming traffic from the user provided MAC address.
sudo iptables -I INPUT -m mac --mac-source $mac_addr -j DROP

# Tell user the process is complete.
echo "Incoming traffic from: $mac_addr is now blocked"
