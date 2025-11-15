#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to close port 22 (SSH) for incoming and outgoing traffic.

# Close port 22 for incoming traffic
sudo iptables -I INPUT -p tcp --dport 22 -j DROP

# Close port 22 for outgoing traffic
sudo iptables -I OUTPUT -p tcp --dport 22 -j DROP

# Let the user know the process is complete
echo "Port 22: Closed"
