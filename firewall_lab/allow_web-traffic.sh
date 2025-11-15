#!/bin/bash
# Camren Smith
# 11/9/2025
# A script to open ports 80 and 443 (HTTP and HTTPS) and redirect incoming traffic from port 80 to 8080.

# Open port 80
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Open port 443
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Open port 8080
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

# Redirect traffic bound for port 80 to 8080
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

# Let the user know the process is complete
echo "Port 80: OPEN"
echo "Port 443: OPEN"
echo "Traffic destined for port 80 will now be redirected to port 8080..."
