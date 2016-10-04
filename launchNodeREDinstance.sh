#!/bin/bash

if [ $# -ne 1 ]; then
	echo Syntax: $0 instance_name
	exit 1
fi

NAME=$1

SUBDOMAIN=.my.apps.tailab.eu

DOCKER_INSTANCE_NAME=nodered-$NAME

NODERED_DATA_VOLUME=nodered_data_$NAME

# Check if volume exists already
docker volume inspect $NODERED_DATA_VOLUME > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo ERROR: Data volume $NODERED_DATA_VOLUME exists already. Check or restart Docker container $DOCKER_INSTANCE_NAME
	exit 2
fi

echo This script will create a Docker instance named $DOCKER_INSTANCE_NAME with its data stored in $NODERED_DATA_VOLUME

echo Type password for account admin and press ENTER:
read -s PASSWORD

# Run Docker container that will generate settings.js in /data with the right password for admin
docker run --rm -v $NODERED_DATA_VOLUME:/data maski/nodered-docker-pwdgenerator /tmp/generate-settings.sh $PASSWORD

# Run Node-RED with the same volume and the variable so that jwilder/nginx-proxy automatically proxies it
docker run -d --name nodered-$NAME -e VIRTUAL_HOST=$NAME$SUBDOMAIN -v $NODERED_DATA_VOLUME:/data maski/node-red-docker

echo You should now be able to login to the new Node-RED instance at http://$NAME$SUBDOMAIN
