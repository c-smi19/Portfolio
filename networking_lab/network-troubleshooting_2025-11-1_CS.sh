#!/bin/bash
# Camren Smith
# 11/1/2025
# A script that provides troubleshooting tips for network issues on Ubuntu or CentOS servers.

# Asking the user what OS they are troubleshooting.
echo "Are you using 1. Ubuntu or 2. CentOS? (enter 1 or 2)"
read -r what_os

# Troubleshooting Ubuntu machine.
if [ $what_os = "1" ]; then
	echo "Let's troubleshoot your Ubuntu machine! What problem are you seeing?)"
	echo "1. No internet connection, 2. Service/app not functioning (enter 1 or 2)"
	read -r question1
	
	# Troubleshooting a bad internet connection.
	if [ $question1 = "1" ]; then
		ip addr show
		echo ""
		echo "Do your network settings look correct? (enter yes or no)"
		read -r question2

		# Solution 1
		if [ $question2 = "yes" ]; then
			echo "Restart your router and/or contact your network admin for more help."
			echo "Thank you - Goodbye."
		
		# Solution 2
		elif [ $question2 = "no" ]; then
			echo "To change network setting go to /etc/neplan/50-cloud-init.yaml"
			echo "If that doesn't work contact your network admin."
			echo "Thank you - Goodbye."

		else
			echo "Error: Invalid Selection"

		fi
	
	# Troubleshooting a nonfunctional service.
	elif [ $question1 = "2" ]; then

		# Solution
		echo "Enter the command: systemctl restart <service_name> (where <service name> is the name of the nonfunctioning service)." 
		echo "Thank you - Goodbye."
	
	else 
		echo "Error: Invalid Selection"
	fi

# Treoubleshooting CentOS machine.
elif [ $what_os = "2" ]; then
	echo "Let's troubleshoot your CentOS machine! What problem are you seeing?)"
	echo "1. No internet connection, 2. Service/app not functioning (enter 1 or 2)"
	read -r question1
	# Troubleshooting a bad internet connection.
	if [ $question1 = "1" ]; then
		ip addr show
		echo ""
		echo "Do your network settings look correct? (enter yes or no)"
		read -r question2

		# Solution 1
		if [ $question2 = "yes" ]; then
			echo "Restart your router and/or contact your network admin for more help."
			echo "Thank you - Goodbye."
		
		# Solution 2
		elif [ $question2 = "no" ]; then
			echo "To change network setting go to /etc/NetworkManager/system-connections/"
			echo "Or you can use the nmcli command(s) to make config changes"
			echo "If that doesn't work contact your network admin."
			echo "Thank you - Goodbye."

		else
			echo "Error: Invalid Selection"
		
		fi

	# Troubleshooting a nonfunctional service.
	elif [ $question1 = "2" ]; then

		# Solution
		echo "Enter the command: systemctl restart <service_name> (where <service name> is the name of the nonfunctioning service)." 
		echo "Thank you - Goodbye."
	
	else 
		echo "Error: Invalid Selection"
	fi

else
	echo "Error: Invalid Selection"
	
fi
