FROM stackbrew/ubuntu:13.04

ADD files/etcdctl /usr/bin/etcdctl
ADD files/docker /usr/bin/docker
ADD files/libdevmapper.so.1.02 /lib/libdevmapper.so.1.02
ADD files/libsqlite3.so.0 /lib/libsqlite3.so.0
ADD files/docker-reg.sh /usr/bin/docker-reg.sh

ENTRYPOINT ["/usr/bin/docker-reg.sh"]
