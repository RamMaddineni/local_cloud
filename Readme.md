# Local Cloud Deployment System

This repository provides a self-hosted deployment system that supports Linux environments and Windows (via WSL). It uses Docker and Docker Compose to run a containerized web application with Caddy as a reverse proxy.

## Features

1. Cross-platform support (Linux and Windows via WSL)
2. Automatic HTTPS using Caddy as a reverse proxy
3. Containerized web application using Docker and Docker Compose
4. Continuous deployment system
5. Secure configuration with proper firewall settings
6. Public access support via ngrok
7. A scalable foundation to add databases, analytics, or other services

## Prerequisites

### For Windows (Using WSL):
- Windows 10/11 with WSL2 enabled
- Ubuntu on WSL (20.04 or newer recommended)
- Basic system utilities (will be installed by setup script)

### For Linux:
- Ubuntu 20.04 or newer
- Basic system utilities (will be installed by setup script)

## Directory Structure

```
.
├── deploy/
│   └── linux/
│       ├── deploy.sh
│       └── setup.sh
├── docker-compose.yml
├── Dockerfile
├── Caddyfile
├── nginx.conf
└── index.html
```

## Setup Instructions

### Windows Setup (Using WSL):

1. Enable WSL2 if not already enabled:
   ```powershell
   # Run in PowerShell as Administrator
   wsl --install
   ```

2. Install Ubuntu on WSL (if not already installed):
   ```powershell
   # Run in PowerShell as Administrator
   wsl --install -d Ubuntu
   ```

3. Open Ubuntu on WSL and clone this repository:
   ```bash
   # Create a directory for your repositories
   mkdir -p ~/repos
   cd ~/repos
   git clone <your-repo-url>
   cd local_cloud
   ```

4. Run the Linux setup script:
   ```bash
   ./deploy/linux/setup.sh
   ```

5. The script will:
   - Install required packages (Docker, Docker Compose, etc.)
   - Configure Docker and system services
   - Set up the deployment environment
   - Create a cron job for continuous deployment

### Linux Setup:

1. Clone this repository
2. Navigate to the project directory
3. Run the Linux setup script:
   ```bash
   ./deploy/linux/setup.sh
   ```
4. The script will:
   - Install required packages
   - Configure Docker and system services
   - Set up firewall rules
   - Create a cron job for continuous deployment

## Manual Deployment

If you prefer to deploy manually without the continuous deployment:

```bash
./deploy/linux/deploy.sh
```

## Accessing the Application

### Local Access
Once deployed, the application will be available at:
- http://localhost (Port 80)
- https://localhost (Port 443)

### Public Access (Using ngrok)
To make your application accessible from anywhere on the internet:

1. Sign up for a free account at https://ngrok.com/signup

2. Install ngrok in WSL/Linux:
   ```bash
   # Add ngrok repository
   curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
   echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
   
   # Install ngrok
   sudo apt update
   sudo apt install ngrok
   ```

3. Get your authtoken from https://dashboard.ngrok.com/get-started/setup and configure it:
   ```bash
   ngrok config add-authtoken YOUR_AUTH_TOKEN
   ```

4. Start ngrok to expose your application:
   ```bash
   ngrok http 80
   ```

5. You'll get a public URL (e.g., `https://abc123.ngrok.io`) that you can share with anyone.

Important Notes about ngrok:
- Keep the ngrok terminal window open while sharing
- The URL changes each time you restart ngrok (free tier)
- Perfect for development, testing, and temporary sharing
- For permanent public access, consider buying a domain and proper hosting

## Adding Custom Domain

To use a custom domain:
1. Update the Caddyfile with your domain name
2. Ensure your DNS records point to your server
3. Redeploy the application.

## Troubleshooting

### Windows (WSL):
- Check WSL status: `wsl --status`
- Restart WSL if needed: `wsl --shutdown` then reopen Ubuntu
- Check Docker service in WSL: `service docker status`
- Check deployment logs: `tail -f /var/log/local_cloud_deploy.log`
- Verify Docker is running: `docker ps`

### Linux:
- Check system logs: `sudo journalctl -u docker`
- Check deployment logs: `tail -f /var/log/local_cloud_deploy.log`
- Verify services are running: `sudo systemctl status docker`

### ngrok Issues:
- If ngrok shows "connection refused", ensure your Docker containers are running
- Check ngrok status: `ngrok status`
- Verify your authtoken: `ngrok config check`
- For tunneling issues, try: `ngrok http 80 --log=stdout`

## Contributing

Feel free to submit issues and enhancement requests!
