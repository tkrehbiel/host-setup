# Run this script to get a Let's Encrypt certificate.
# This requires a publicly accessible domain name to be attached to the server.
# So that Let's Encrypt can reach an URL that looks like:
# http://www.domainname/.well-known/...

# get cert from let's encrypt
if [ ! -f /etc/letsencrypt/live/$uvtek_hostname/cert.pem ]; then
    echo "There is no Let's Encrypt certificate yet."
fi

set -x
sudo certbot --nginx
