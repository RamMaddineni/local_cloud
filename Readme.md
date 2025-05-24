# This setup achieves the following:

1. A self-hosted deployment system on Ubuntu using Docker and Docker Compose.
2. Automatic HTTPS using Caddy as a reverse proxy.
3. A secure server with SSH enabled and firewall configured via UFW.
4. A directory structure to organize services under ~/services.
5. A sample web application containerized and reverse proxied with Caddy.
6. SSH key generation for secure Git operations (e.g., pulling from GitHub).
7. A deploy.sh script that pulls the latest code, rebuilds, and redeploys the app.
8. A cron job that checks for updates every minute and redeploys automatically (continuous deployment).
9. A scalable foundation to add databases (PostgreSQL, MySQL), analytics, or other services later.


To acheive that , we need to run below commands :

```bash
# 1. Prepare Your Ubuntu Machine
sudo apt update
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# 2. Install Required Tools
sudo apt install git docker.io docker-compose curl ufw
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# 3. Harden the System
sudo ufw allow OpenSSH
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable


cd ~/Desktop/repos/local_cloud

# 5. Sample docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  web:
    build: .
    container_name: local_cloud_app
    restart: unless-stopped
    networks:
      - appnet

  caddy:
    image: caddy:latest
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
    networks:
      - appnet

networks:
  appnet:

volumes:
  caddy_data:
EOF

# 6. Sample Caddyfile
cat <<EOF > Caddyfile
yourdomain.com {
  reverse_proxy local_cloud_app:8080
}
EOF

# 7. Set up SSH keys & Git ,if already not exists.
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub

# 8. Deploy Your App
docker-compose up --build -d

# 9. Continuous Deployment with Cron
cat <<EOF > deploy.sh
#!/bin/bash
cd /home/\$(whoami)/Desktop/repos/local_cloud
git pull
docker-compose build
docker-compose up -d
EOF

chmod +x deploy.sh
(crontab -l 2>/dev/null; echo "* * * * * /home/\$(whoami)/Desktop/repos/local_cloud/deploy.sh >> /var/log/local_cloud_deploy.log 2>&1") | crontab -

# 10. Optional Enhancements
# - Add PostgreSQL container if needed
# - Add analytics containers like Plausible
# - Improve deploy.sh to handle zero-downtime deploys if needed
```
