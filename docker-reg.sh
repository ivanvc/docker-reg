#!/bin/bash

MACH=$1
PORT=$2
SERV=$3
IP_PORT=$(/usr/bin/docker -H=unix:///docker.sock port $MACH $PORT)
IP=$(echo $IP_PORT | awk -F':' '{print $1}')
PORT=$(echo $IP_PORT | awk -F':' '{print $2}')
MACH=$(echo $MACH | sed ':l s/\./_/;tl')

CTL="etcdctl -C http://${ETCD_PORT_10000_TCP_ADDR}:${ETCD_PORT_10000_TCP_PORT}"

KEY_IP_PORT="/services/${SERV}/ip_port/${MACH}"
KEY_IP="/services/${SERV}/ip/${MACH}"
KEY_PORT="/services/${SERV}/port/${MACH}"
trap "$CTL rm $KEY_IP_PORT; $CTL rm $KEY_IP; $CTL rm $KEY_PORT; exit" SIGHUP SIGINT SIGTERM

while [ 1 ]; do
  $CTL --debug set "$KEY_IP_PORT" "${IP_PORT}" --ttl 5
  $CTL --debug set "$KEY_IP" "${IP}" --ttl 5
  $CTL --debug set "$KEY_PORT" "${PORT}" --ttl 5
  sleep 1
done
