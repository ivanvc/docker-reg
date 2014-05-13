#!/bin/bash

MACH=$1
PORT=$2
SERV=$3
shift
shift
shift
KV=$@
DOCKER_PORT=$(/usr/bin/docker -H=unix:///docker.sock port $MACH $PORT)

CTL="etcdctl -C http://${ETCD_PORT_10000_TCP_ADDR}:${ETCD_PORT_10000_TCP_PORT}"

KEY="/services/${SERV}/${MACH}"
trap "$CTL rm $KEY; exit" SIGHUP SIGINT SIGTERM

while [ 1 ]; do
  $CTL --debug set "$KEY" "${DOCKER_PORT}" --ttl 5
  sleep 1
done
