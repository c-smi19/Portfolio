#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to open port 22 (SSH) to incoming and outgoing traffic.

# Open port 22 for incoming traffic
sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT

# Open port 22 for outgoing traffic
sudo iptables -I OUTPUT -p tcp --dport 22 -j ACCEPT

# Let the user know the process is complete
echo "Port 22: OPEN"
