#!/bin/bash

LOG_DIR=/var/local/mesos/logs/master
WORK_DIR=/var/local/mesos/master

# clean-up logs and work directory
rm -rf /tmp/slave
rm -rf "${LOG_DIR}/*"

sudo mkdir -p /tmp/logs
mesos-master --work_dir=${WORK_DIR} \
    --ip=192.168.33.10 --port=5050 \
    --hostname=mesos-master --log_dir=${LOG_DIR} >/dev/null 2>&1 &
