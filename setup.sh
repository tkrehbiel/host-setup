# Setup Ubuntu host

# First login as root and create a new user with sudo privileges
# - adduser name
# - usermod -aG sudo name
# Login as name
# Run this script

username=$(whoami)
echo "Current user is $username"

mkdir -p ~/.ssh
if [ ! -f ~/.ssh/authorized_keys ]; then
    echo "Enter public key for login:"
    read pubkey
    echo $pubkey >~/.ssh/authorized_keys
    chown $username:$username ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# allow ssh through ubuntu firewall!
sudo ufw allow ssh

echo "Reminder: Don't forget to disable root and password login"

sudo apt update
sudo apt upgrade
sudo apt install nginx
sudo ufw allow 443
sudo ufw allow 8080

echo "Reminder: Enable ufw with sudo ufw enable"

