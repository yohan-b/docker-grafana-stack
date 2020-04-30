#!/bin/bash
#Absolute path to this script
SCRIPT=$(readlink -f $0)
#Absolute path this script is in
SCRIPTPATH=$(dirname $SCRIPT)

cd $SCRIPTPATH

for NETWORK in mysqlnet reverse-proxy
do
    sudo docker network inspect ${NETWORK} &> /dev/null && continue
    sudo docker network create ${NETWORK}
    sudo docker network inspect ${NETWORK} &> /dev/null || \
    { echo "ERROR: could not create network ${NETWORK}, exiting."; exit 1; }
done

sudo -E bash -c 'docker-compose up --no-start'
