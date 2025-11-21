#!/bin/bash

# ===============================================
# Ubuntu Server Hardening Script
# CAUTION: Run only after reviewing ALL steps.
# Usage: sudo bash harden_server.sh
# ===============================================

# Function to display messages and keep the output clean
log_info() {
    echo ""
    echo "=================================================================="
    echo ">> $1"
    echo "=================================================================="
}

# Check if the script is run as root (necessary for system-wide changes)
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (e.g., 'sudo bash $0')"
  exit 1
fi

# --- 1. System Updates and Package Installation ---
# This section ensures the system is up-to-date and installs necessary security tools.
log_info "1/5: Updating system and installing core security packages (Fail2Ban, UFW, Unattended Upgrades)..."

# Update package lists from repositories.
apt update -y
# Upgrade all installed packages to their latest versions (-y confirms automatically).
apt upgrade -y
# Install UFW (Uncomplicated Firewall), Fail2Ban (intrusion prevention), and
# Unattended Upgrades (automatic security patch installation).
apt install -y ufw fail2ban unattended-upgrades

log_info "System updates and security packages installed."


# --- 2. Configure Firewall (UFW) ---
# UFW (Uncomplicated Firewall) manages network traffic, blocking unauthorized connections.
log_info "2/5: Configuring Uncomplicated Firewall (UFW)..."

# Temporarily disable and reset UFW rules for a clean configuration start.
ufw disable
ufw reset

# Allow standard SSH port (22). This MUST be done before enabling the firewall,
# otherwise you will be locked out of the server. CHANGE THIS IF YOU USE A DIFFERENT PORT.
ufw allow 22/tcp

# Allow web server traffic (optional - uncomment if running a web server)
# ufw allow http  # Opens TCP port 80 (HTTP)
# ufw allow https # Opens TCP port 443 (HTTPS)

# Enable UFW. The default policy is to DENY all incoming connections not explicitly allowed.
echo "y" | ufw enable

log_info "UFW status:"
# Display the current firewall rules to verify the configuration.
ufw status verbose


# --- 3. Configure SSH Security ---
# This hardens the SSH daemon configuration file to prevent unauthorized remote access.
log_info "3/5: Hardening SSH Configuration (/etc/ssh/sshd_config)..."

SSHD_CONFIG="/etc/ssh/sshd_config"
# Create a backup of the original SSH configuration file before making changes.
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak.$(date +%F)"

# 3.1 Disable Root Login
# IMPORTANT: You must have a non-root user with sudo created and working before running this!
log_info "Disabling root SSH login (PermitRootLogin no)."
# Use sed (stream editor) to find and replace any instance of 'PermitRootLogin' to 'PermitRootLogin no'.
# This prevents direct login as the powerful 'root' user, which is a major security risk.
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' "$SSHD_CONFIG"
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' "$SSHD_CONFIG"
sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin no/' "$SSHD_CONFIG"
# If the line doesn't exist (grep -q checks quietly), append the setting to the file.
if ! grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
    echo "PermitRootLogin no" >> "$SSHD_CONFIG"
fi

# 3.2 Enable Password Authentication
log_info "Keeping password authentication ENABLED."
# Password authentication is kept enabled as requested. It's less secure than keys, 
# but Fail2Ban will help protect against brute-force attacks.
# The previous commands to disable it are intentionally commented out here.


# 3.3 Ensure protocol 2 is used
log_info "Ensuring SSH Protocol 2 is enforced."
# Protocol 2 is the modern, more secure version of the SSH protocol.
# Use sed to ensure 'Protocol 2' is set in the configuration file.
sed -i 's/^#Protocol 2/Protocol 2/' "$SSHD_CONFIG"
sed -i 's/^Protocol 1/Protocol 2/' "$SSHD_CONFIG"
# If the Protocol line is missing, append 'Protocol 2'.
if ! grep -q "^Protocol" "$SSHD_CONFIG"; then
    echo "Protocol 2" >> "$SSHD_CONFIG"
fi

# 3.4 Restart SSH service to apply changes
# This reloads the sshd_config file so the new settings take effect immediately.
service ssh restart
log_info "SSH service restarted. Please test your connection immediately!"


# --- 4. Configure Fail2Ban ---
# Fail2Ban actively scans log files (like SSH logs) and automatically blocks IPs
# that show suspicious activity (e.g., too many failed login attempts).
log_info "4/5: Configuring and enabling Fail2Ban..."

# Copy default jail config to jail.local. We use the .local file because it
# overrides the original /etc/fail2ban/jail.conf and won't be overwritten 
# during future package updates.
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Enable Fail2Ban to start automatically whenever the server boots up.
systemctl enable fail2ban
# Start the Fail2Ban service immediately.
systemctl start fail2ban

log_info "Fail2Ban is enabled and running."
log_info "Script finished. A reboot is recommended to apply all changes."