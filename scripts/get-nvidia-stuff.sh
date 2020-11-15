#!/bin/sh

REPO=https://gitlab.com/nvidia/container-images/cuda/-/raw/master/dist
VERSION=11.0
CUDNN=cudnn8
OS=ubuntu18.04-x86_64

cat <<EOF | grep -v '^FROM' | grep -v '^ARG IMAGE_NAME' | grep -v 'LABEL maintainer' > 1_CUDA-$VERSION.Dockerfile
# Cuda stuff for v$VERSION

## $REPO/$VERSION/$OS/base/Dockerfile

###########################
### Base
###########################
# $REPO/$VERSION/$OS/base/Dockerfile

$(curl -s $REPO/$VERSION/$OS/base/Dockerfile)

# ###########################
# ### Devel
# ###########################
# # $REPO/$VERSION/$OS/devel/Dockerfile
#
# \$(curl -s $REPO/$VERSION/$OS/devel/Dockerfile)

###########################
### Runtime
###########################
# $REPO/$VERSION/$OS/runtime/Dockerfile

$(curl -s $REPO/$VERSION/$OS/runtime/Dockerfile)

###########################
### CudNN
###########################
# $REPO/$VERSION/$OS/runtime/$CUDNN/Dockerfile

$(curl -s $REPO/$VERSION/$OS/runtime/$CUDNN/Dockerfile)

EOF
