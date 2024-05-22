#####################################################
#     InterSystems IRIS Docker Image Builder        #
#                   CONFIG FILE                     #
#   Edit this file according to your requirements   #
#####################################################

# Path to IRIS docker image (a docker login prior to executing 
# this script is required if Intersytems registry is used)
IRIS_DOCKER_IMAGE="intersystems/irishealth-community:2024.1" 

# Webserver port
WEBSERVER_PORT="52773"

# Superserver port
SUPERSERVER_PORT="1972"

# Container name (Make sure the name is not in use)
CONTAINER_NAME="irishealth-demo" 

# Docker Image name
IMAGE_NAME=$CONTAINER_NAME

# Docker Image tag
IMAGE_TAG="latest"

# Optional: Set password for default IRIS users
IRIS_PW="SYS"

# Use a license key file. Place a file with *.key ending in the same folder as this script.
# Disable if community edition is used
USE_LICENSE_KEY=0

# Run docker compose up after build to start the container(s)
RUN_COMPOSE_UP=1

# Set to "y" to export the image after build process as GZip file or to "n" to skip the export. 
# If EXPORT_IMAGE is set to "" the script will ask if the image should be exported.
EXPORT_IMAGE="n"

# Run docker commands as root by using sudo (this might be required depending on the docker installation)
USE_SUDO_FOR_DOCKER=0
