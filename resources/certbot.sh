# Create a let's encrypt certificate using certbot. 
# Pass email as the first argument and the domain as the second.
function create_letsencrypt_cert() {
    domain=$1
    email=$2
    # Install dependencies
    snap install --classic certbot
    ln -s /snap/bin/certbot /usr/bin/certbot 2>/dev/null

    # create cert
    certbot certonly \
        --non-interactive \
        --agree-tos \
        --no-eff-email \
        --standalone \
        --email "$email" \
        --cert-name iris-wg \
        --domains "$domain"

    if [ $? -ne 0 ]; then exit 1; fi

    # Create deploy hook
    cat << EOF > /etc/letsencrypt/renewal-hooks/deploy/update-web-gateway.sh
cp /etc/letsencrypt/live/iris-wg/cert.pem "$(pwd)/volumes/webgateway/web-gateway-cert.pem"
cp /etc/letsencrypt/live/iris-wg/privkey.pem "$(pwd)/volumes/webgateway/web-gateway-key.pem"
# This will trigger the webgateway to restart apache
echo "# Certificate renewal: \$(date)" >> "$(pwd)/volumes/webgateway/CSP.conf"
chown $USER "$(pwd)/volumes/webgateway/web-gateway-cert.pem"
chown $USER "$(pwd)/volumes/webgateway/web-gateway-key.pem"
chown $USER "$(pwd)/volumes/webgateway/CSP.conf"
EOF

    chmod a+x /etc/letsencrypt/renewal-hooks/deploy/update-web-gateway.sh
    /etc/letsencrypt/renewal-hooks/deploy/update-web-gateway.sh
}