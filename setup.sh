#!/bin/bash

#################################################
#   InterSystems IRIS Docker Image Builder      #
#                 Script FILE                   #
#  Author: Andreas Schuetz (InterSystems DACH)  #
#################################################

# Load config
source ./config.sh

echo "InterSystems IRIS container setup script"

# Get docker command
if [[ "$USE_SUDO_FOR_DOCKER" -eq 1 ]]; then
    DOCKERCMD="sudo docker"
else
    DOCKERCMD="docker"
fi

# Down running containers
if [ -f docker-compose.yaml ]; then
    $DOCKERCMD compose down
    $DOCKERCMD image rm ${IMAGE_NAME}:${IMAGE_TAG} 2>/dev/null
fi

# Create Dockerfile
cat Dockerfile-template | \
sed "s|<IRIS_DOCKER_IMAGE>|$IRIS_DOCKER_IMAGE|" \
> Dockerfile

# Set license settings in dockerfile
if [[ "$USE_LICENSE_KEY" -eq 1 ]]; then
    LICENSE_FILE=$(ls *.key | head -n 1)
    if [[ -z "$LICENSE_FILE" ]]; then
        echo "License key file not found. Please make sure there is an IRIS license key file (.key) in the script directory."
        exit 1
    fi

    cat Dockerfile | \
    sed -e "s|<LICENSE_FILE>|\"./$LICENSE_FILE\"|" \
    > Dockerfile.tmp
else
    cat Dockerfile | \
    sed -e '/<LICENSE_FILE>/d' \
    > Dockerfile.tmp
fi
mv Dockerfile.tmp Dockerfile

# Set password settings in dockerfile
if [ -n "$IRIS_PW" ]; then
    echo "$IRIS_PW" > ./password.txt
    cat Dockerfile | \
    sed "s|<PASSWORD_FILE>|./password.txt|" \
    > Dockerfile.tmp
else
    cat Dockerfile | \
    sed -e '/<PASSWORD_FILE>/,+2d' \
    > Dockerfile.tmp
fi
mv Dockerfile.tmp Dockerfile

# Prepare docker-compose file
cat docker-compose-template.yaml | \
sed "s|<CONTAINER_NAME>|$CONTAINER_NAME|" | \
sed "s|<IMAGE_NAME>|$IMAGE_NAME|" | \
sed "s|<IMAGE_TAG>|$IMAGE_TAG|" | \
sed "s|<WEBSERVER_PORT>|$WEBSERVER_PORT|" | \
sed "s|<SUPERSERVER_PORT>|$SUPERSERVER_PORT|" \
> docker-compose.yaml

# Docker build
$DOCKERCMD compose --progress=plain build

# Clean up
rm ./password.txt

# Run docker compose if enabled
if [[ "$RUN_COMPOSE_UP" -eq 1 ]]; then
    $DOCKERCMD compose up -d
fi

# Export image
if [ -z "$EXPORT_IMAGE" ]; then
    bold=$(tput bold)
    normal=$(tput sgr0)
    read -p "Do you wish to export the docker image as GZip file? [y|${bold}n${normal}]:" EXPORT_IMAGE
fi

case $EXPORT_IMAGE in
    [Yy]* ) $DOCKERCMD save ${IMAGE_NAME}:${IMAGE_TAG} | gzip > ${IMAGE_NAME}_${IMAGE_TAG}.tgz;;
    * ) echo "To export the image run '$DOCKERCMD save ${IMAGE_NAME}:${IMAGE_TAG} | gzip > ${IMAGE_NAME}_${IMAGE_TAG}.tgz'";;
esac
