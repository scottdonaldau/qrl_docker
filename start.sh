#!/usr/bin/env bash

# Adjust this
LOCAL_QRL_DIR=${HOME}/.qrl

# Create and start the container
NODE_NAME=qrl_node
mkdir -p ${LOCAL_QRL_DIR}
mv ./Dockerfile_single ./Dockerfile
docker build -t qrl_single .
mv ./Dockerfile ./Dockerfile_single

docker run -dt \
    --name ${NODE_NAME} \
    -p 127.0.0.1:8888:18888 \
    -p 127.0.0.1:2000:12000 \
    -p 127.0.0.1:8080:18080 \
    -v ${LOCAL_QRL_DIR}:/root/.qrl \
    qrl_single
