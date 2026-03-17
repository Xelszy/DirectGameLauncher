#!/bin/bash

echo "Updating system..."

sudo apt update -y
sudo apt upgrade -y

echo "Installing nginx..."

sudo apt install nginx -y

echo "Starting nginx..."

sudo systemctl start nginx
sudo systemctl enable nginx

echo "Opening firewall..."

sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 22
sudo ufw reload

echo "Creating game directory..."

sudo mkdir -p /var/www/html/game

echo "Setting permissions..."

sudo chmod -R 755 /var/www/html/game

echo "Enabling nginx autoindex..."

sudo sed -i '/location \/ {/a \        autoindex on;' /etc/nginx/sites-available/default

echo "Testing nginx config..."

sudo nginx -t

echo "Restarting nginx..."

sudo systemctl restart nginx

echo "Installing tools..."

sudo apt install python3 python3-pip -y

echo "Installing utilities..."

sudo apt install unzip unrar wget aria2 tree curl -y

SERVER_IP=$(curl -s ifconfig.me)

echo ""
echo "Setup complete!"
echo "Server URL:"
echo "http://$SERVER_IP/game/"
echo ""
