#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to close port 23 (telnet).

# Close port 23
sudo iptables -A INPUT -p tcp --dport 23 -j DROP

# Let the user know the process is complete
echo "Port 23: CLOSED"
