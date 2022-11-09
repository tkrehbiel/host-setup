# Setup Ubuntu host

# First login as root and create a new user with sudo privileges
# - adduser name
# - usermod -aG sudo name
# Login as name
# Run this script

username=$(whoami)

mkdir -p ~/.ssh
echo "Enter public key for login:"
read pubkey
echo $pubkey >~/.ssh/authorized_keys
chown $username:$username ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo "Reminder: Don't forget to disable root and password login"

