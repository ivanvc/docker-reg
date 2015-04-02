#!/bin/bash

cp /usr/bin/etcdctl files
cp /usr/bin/docker files
cp /lib64/libdevmapper.so.1.02 files
cp /lib64/libsqlite3.so.0 files

docker build -t ivan/docker-register .
