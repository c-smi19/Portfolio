#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to open port 3306 (mySQL)

# Open port 3306
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

# Let the user know the process is complete
echo "Port 3306: OPEN"
