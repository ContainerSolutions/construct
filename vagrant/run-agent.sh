#!/bin/bash

LOG_DIR=/var/local/mesos/logs/agent
WORK_DIR=/var/local/mesos/agent
SANDBOX=/var/local/sandbox

# clean-up logs and work directory
rm -rf /tmp/slave
rm -rf "${LOG_DIR}/*"

mesos-slave --work_dir=${WORK_DIR} \
    --ip=192.168.33.11 --port=5051 \
    --master=192.168.33.10:5050 \
    --log_dir=${LOG_DIR} \
    --containerizers=docker,mesos \
    --sandbox_directory=${SANDBOX} >/dev/null 2>&1 &
