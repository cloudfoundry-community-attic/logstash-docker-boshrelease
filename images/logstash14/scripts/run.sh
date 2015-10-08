#!/bin/bash

NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

sed -i "/#cluster.name:.*/a cluster.name: ${NEW_UUID}" /etc/elasticsearch/elasticsearch.yml

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
