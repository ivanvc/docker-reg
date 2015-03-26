#!/bin/bash

SERVICE=$1
CONTAINER_NAME=$2
PORT=$3

CTL="etcdctl -C http://${ETCD_PORT_10000_TCP_ADDR}:${ETCD_PORT_10000_TCP_PORT}"
URI_NAME=$(echo $CONTAINER_NAME | awk '{ gsub(/_/, "-"); print }')
PUBLISHED_PORT=""
[[ -z $PORT ]] && PUBLISHED_PORT=$(/usr/bin/docker port $CONTAINER_NAME $PORT | awk -F':' '{print $2}')

KEY="/services/${SERVICE}/${URI_NAME}"
trap "$CTL rm $KEY; exit" SIGHUP SIGINT SIGTERM

while [ 1 ]; do
  IP=$(/usr/bin/docker inspect $CONTAINER_NAME | grep IPAddress | awk '{ gsub(/[^0-9\.]/, ""); print }')
  VALUE="{\"IP\":\"${IP}\",\"port\":\"${PUBLISHED_PORT}\"}"

  $CTL --debug set "$KEY" "$VALUE" --ttl 5
  sleep 1
done
