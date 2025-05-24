#!/bin/bash

# Update package list
sudo apt update

# Install required packages
sudo apt install -y git docker.io docker-compose curl ufw openssh-server

# Enable and start services
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable ssh
sudo systemctl start ssh

# Add current user to docker group
sudo usermod -aG docker $USER

# Configure firewall
sudo ufw allow OpenSSH
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

# Make deploy script executable
chmod +x "$(dirname "$0")/deploy.sh"

# Setup cron job for continuous deployment
DEPLOY_SCRIPT="$(dirname "$0")/deploy.sh"
(crontab -l 2>/dev/null; echo "* * * * * $DEPLOY_SCRIPT >> /var/log/local_cloud_deploy.log 2>&1") | crontab -

echo "Linux setup completed. Please log out and log back in for docker group changes to take effect." 