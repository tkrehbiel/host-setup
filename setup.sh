# Setup Ubuntu host from scratch

# First login as root and create a new user with sudo privileges
# - adduser name
# - usermod -aG sudo name
# Login as name
# Run this script

username=$(whoami)
echo "Current user is $username"

sudo apt update
sudo apt upgrade

# allow ssh through ubuntu firewall!
sudo ufw allow ssh

# setup ssh private key access
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/authorized_keys ]; then
    echo "Enter public key for login:"
    read pubkey
    echo $pubkey >~/.ssh/authorized_keys
    chown $username:$username ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# install nginx
sudo apt install nginx
sudo ufw allow 443
sudo ufw allow 8080

# install certbot
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

if [ ! -f /etc/letsencrypt/live/$uvtek_hostname/cert.pem ]; then
    sudo certbot --nginx
fi

# nginx config
cp nginx/sites-available/default /etc/nginx/sites-available
sudo systemctl restart nginx

echo "*** Reminders ***"
echo "Disable root and password login: /etc/ssh/sshd_config"
echo "Enable ufw: sudo ufw enable"
