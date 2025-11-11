#!/bin/bash
# Camren Smith
# 10/26/2025
# Bash script that generates network information and outputs it to the terminal and a log file in the networkingLab/netInfo/ directory.

{
# Creating a title at the top of the file.
echo "Network Information - $(date +%Y-%m-%d)"
echo ""

# ping test
echo "Ping test:"
ping -c4 google.com
ping -c4 apple.com

# dns test
echo "DNS Test:"
nslookup youtube.com
nslookup github.com

# Printing system info
echo "System Info:"
uname -a
echo ""

# Printing hostname
echo "Hostname:"
hostname
echo ""

# Printing interface settings.
echo "Interface settings:"
ip addr show
echo ""

# Printing open TCP ports.
echo "Open TCP Ports:"
ss -ta
echo ""

# Printing open UDP ports.
echo "Open UDP Ports:"
ss -ua
echo ""

# Printing active TCP connections.
echo "Active TCP Connections:"
ss -to 
echo ""

# Printing active UDP connections.
echo "Active UDP Connections:"
ss -uo
echo ""

# Outputting the above commands to the log file and terminal.
} | tee -a ~/networkingLab/netInfo/"netInfo_$(date +%Y-%m-%d)_CS.log"
