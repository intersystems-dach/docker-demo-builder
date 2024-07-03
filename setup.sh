#!/bin/bash

#################################################
#   InterSystems IRIS Docker Image Builder      #
#                 Script FILE                   #
#  Author: Andreas Schuetz (InterSystems DACH)  #
#################################################

# Load config
source ./.env
source ./resources/certbot.sh

echo "InterSystems IRIS container setup script"

if [[ "$USE_LETS_ENCRYPT" -eq 1 ]]; then
    if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or using sudo"
    exit
    fi
fi

if [ ! -f ${IRIS_PW_FILE} ]; then
    read -s -p "Enter IRIS default password (output will not be visible): " IRIS_PW
    echo "$IRIS_PW" > ${IRIS_PW_FILE}
    unset IRIS_PW
fi


# Down running containers and clean up old images
docker compose down
docker image rm ${OUTPUT_IMAGE_NAME}:${OUTPUT_IMAGE_TAG} 2>/dev/null

# Create mount volumes
mkdir -p ./volumes/webgateway
mkdir -p ./volumes/iris/license

# Copy web gateway and license files
cp ./resources/CSP.conf ./volumes/webgateway/CSP.conf
cp ./resources/CSP.ini ./volumes/webgateway/CSP.ini

if [ -n "$LICENSE_KEY_PATTERN" ]; then
    KEY_FILE=$(find . -depth 1 -name "$LICENSE_KEY_PATTERN" | head -n 1)
    cp "$KEY_FILE" ./volumes/iris/license/iris.key
    if [ $? -ne 0 ]; then exit 1; fi
fi

# Generate certificates
if [[ "$USE_LETS_ENCRYPT" -eq 1 ]]; then
    create_letsencrypt_cert $WEBGATEWAY_HOSTNAME $LETS_ENCRYPT_EMAIL
else
    # MSYS_NO_PATHCONV=1 is workaround for cygwin and git bash, see https://github.com/git-for-windows/git/issues/577#issuecomment-166118846
    MSYS_NO_PATHCONV=1 openssl req -x509 -newkey rsa:2048 -keyout ./volumes/webgateway/web-gateway-key.pem -out ./volumes/webgateway/web-gateway-cert.pem -sha256 -days 3650 -nodes -subj "/CN=${WEBGATEWAY_HOSTNAME}"   
fi

# Build and create containers
# The CACHEBUST build arg is used to invalidate the build cache if the password has changed.
docker compose --progress=plain build --build-arg "CACHEBUST=$(date -r $IRIS_PW_FILE | openssl sha256)"
docker compose up -d

# Link to portal
echo
echo "http://localhost:${WEBSERVER_PORT}/csp/sys/UtilHome.csp"
echo "https://localhost:${WEBSERVER_PORT_HTTPS}/csp/sys/UtilHome.csp"
echo

# Export image
echo "To export the image run 'docker save ${OUTPUT_IMAGE_NAME}:${IMAGE_TAG} | gzip > ${OUTPUT_IMAGE_NAME}_${OUTPUT_IMAGE_TAG}.tgz'"
