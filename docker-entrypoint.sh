#!/bin/bash

set -e

if [ "$1" = 'go-server' ]; then
    echo export DAEMON=N >> /etc/default/go-server

    mkdir -p /var/lib/go-server/plugins/external/
    cp -R /home/go/plugins/* /var/lib/go-server/plugins/external/ || :

    chown -R go:go /var/lib/go-server
    /etc/init.d/go-server start
    exec tail -f /var/log/go-server/go-server.log
fi

exec "$@"