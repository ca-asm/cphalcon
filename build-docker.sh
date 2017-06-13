#!/bin/bash

REGISTRY=registry.asmdev.ca.com
IMAGE=$REGISTRY/asm/phalcon

docker run --rm -u $(id -u):$(id -g) -v $(realpath ..):/src $IMAGE
