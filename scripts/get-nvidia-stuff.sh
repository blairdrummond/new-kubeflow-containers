#!/bin/sh

REPO=https://gitlab.com/nvidia/container-images/cuda/-/raw/master/dist
VERSION=11.0
OS=ubuntu18.04-x86_64

cat <<EOF | grep -v '^FROM' > 1_CUDA-$VERSION.Dockerfile
# Cuda stuff for v$VERSION

## $REPO/$VERSION/$OS/base/Dockerfile

###########################
### Base
###########################
$(curl -s $REPO/$VERSION/$OS/base/Dockerfile)

###########################
### Devel
###########################
$(curl -s $REPO/$VERSION/$OS/devel/Dockerfile)

###########################
### Runtime
###########################
$(curl -s $REPO/$VERSION/$OS/runtime/Dockerfile)
EOF
