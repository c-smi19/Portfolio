#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to allow incoming traffic from a user specified MAC address.

# Get the MAC address from the user.
echo "Enter the MAC address you want to allow"
read -r mac_addr

# Allow incoming traffic from the user provided MAC address.
sudo iptables -I INPUT -m mac --mac-source $mac_addr -j ACCEPT

# Tell user the process is complete.
echo "Incoming traffic from: $mac_addr is now allowed"
