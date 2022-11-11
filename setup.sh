# Setup Ubuntu host from scratch
# Designed to run this repeatedly with no bad side effects

# Before running this, login as root and create a new user with sudo privileges.
# - adduser name
# - usermod -aG sudo name

# Then login as the new user.

# Test sudo access.
# sudo apt update
# sudo apt upgrade
# sudo nano /etc/ssh/sshd_config
# Set `PermitRootLogin no`

# - `ssh-keygen -t ed25519 -C "email@example.com"`
# - Add ~/.ssh/id_ed25519.pub to github ssh keys
# - sudo apt install git-core
# - git clone git@github.com:(repo)

# Go the repo directory and run this script.

# exit on any errors
set -e

username=$(whoami)
echo "Current user is $username"

# display commands
set -x

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
sudo ufw allow 80

# install certbot
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
if [ ! -f /usr/bin/certbot ]; then
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
fi

# get cert from let's encrypt
if [ ! -f /etc/letsencrypt/live/$uvtek_hostname/cert.pem ]; then
    # depends on getting a domain name hooked up to the server
    #sudo certbot --nginx
    echo "There is no Let's Encrypt certificate yet."
fi

# finalize nginx config
sudo systemctl stop nginx
sudo rm -f /etc/nginx/sites-enabled/default
sudo rm -f /etc/nginx/sites-available/default
envsubst <nginx/default.template >sub.txt
sudo cp sub.txt /etc/nginx/sites-enabled/default
rm -f sub.txt
sudo systemctl restart nginx

set +x

echo "*** Reminders ***"
echo "Disable root and password login: /etc/ssh/sshd_config"
echo "Enable ufw: sudo ufw enable"
