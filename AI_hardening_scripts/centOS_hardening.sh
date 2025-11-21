#!/bin/bash

### THIS WAS WRITTEN BY CHATGPT USE AT YOUR OWN RISK ###


# Basic System Hardening Script for CentOS Stream 9
# Run as root or with sudo

echo "Starting basic system hardening..."

# 1. Update the system
echo "[*] Updating system packages..."
dnf update -y

# 2. Set timezone (optional)
echo "[*] Setting timezone to EST..."
timedatectl set-timezone EST

# 3. Enable and configure firewall
echo "[*] Configuring firewall..."
dnf install -y firewalld
systemctl enable --now firewalld

# Remove all existing rules
firewall-cmd --permanent --remove-service=dhcpv6-client
firewall-cmd --permanent --remove-service=http
firewall-cmd --permanent --remove-service=https
firewall-cmd --permanent --remove-service=smtp
firewall-cmd --permanent --remove-service=dns
firewall-cmd --permanent --remove-service=ftp

# Allow only SSH
firewall-cmd --permanent --add-service=ssh

# Reload firewall to apply changes
firewall-cmd --reload
echo "[*] Firewall configured to allow only SSH."

# 4. Disable unnecessary services
echo "[*] Disabling unnecessary services..."
for svc in avahi-daemon cups dhcpd slapd nfs rpcbind; do
    if systemctl list-unit-files | grep -q "$svc"; then
        systemctl disable --now $svc
    fi
done

# 5. Secure SSH
echo "[*] Hardening SSH..."
SSH_CONFIG="/etc/ssh/sshd_config"
cp $SSH_CONFIG "${SSH_CONFIG}.bak"

sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' $SSH_CONFIG

systemctl restart sshd

# 6. Enable automatic updates
echo "[*] Enabling automatic security updates..."
dnf install -y dnf-automatic
systemctl enable --now dnf-automatic.timer

# 7. Enable SELinux in enforcing mode
echo "[*] Ensuring SELinux is enabled and enforcing..."
setenforce 1
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

# 8. Configure fail2ban (optional but recommended)
echo "[*] Installing and configuring Fail2Ban..."
dnf install -y epel-release
dnf install -y fail2ban
systemctl enable --now fail2ban

# 9. Basic sysctl hardening
echo "[*] Applying basic sysctl security settings..."
cat <<EOL >> /etc/sysctl.d/99-harden.conf
# Disable IP forwarding
net.ipv4.ip_forward = 0
# Enable TCP SYN cookies
net.ipv4.tcp_syncookies = 1
# Ignore ICMP broadcasts
net.ipv4.icmp_echo_ignore_broadcasts = 1
# Ignore bogus ICMP errors
net.ipv4.icmp_ignore_bogus_error_responses = 1
# Enable source route verification
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
EOL

sysctl --system

echo "Basic hardening complete! Review backup config files before making further changes."