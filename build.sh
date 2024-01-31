#!/bin/bash

#set -eu

help() {
    echo "Build the project and create docker images for Demo"
    echo
    echo "Usage $0 <tag>"
    echo "tag: The tag of docker images in the form '1.0.0' or 'latest'"
}

if [ -z "$1" ]; then
    help
    exit 1
fi

REPOSITORY='k8s-spring-boot-app'
TAG=$1
PLATFORM_FLAG=""

os=$(uname -s)
arch=$(uname -m)
OS=${OS:-"${os}"}
ARCH=${ARCH:-"${arch}"}
OS_ARCH=""

BIN=${BIN:-crank}

unsupported_arch() {
  local os=$1
  local arch=$2
  echo "This build script does not support $os / $arch at this time."
  exit 1
}

case $OS in
#  CYGWIN* | MINGW64* | Windows*)
#    if [ $ARCH = "x86_64" ]
#    then
#      OS_ARCH=windows_amd64
#      BIN=crank.exe
#    else
#      unsupported_arch $OS $ARCH
#    fi
#    ;;
  Darwin)
    case $ARCH in
      x86_64|amd64)
        OS_ARCH=darwin_amd64
        ;;
      arm64)
        OS_ARCH=darwin_arm64
        PLATFORM_FLAG="--platform linux/amd64"
        ;;
      *)
        unsupported_arch $OS $ARCH
        ;;
    esac
    ;;
  Linux)
    case $ARCH in
      x86_64|amd64)
        OS_ARCH=linux_amd64
        ;;
      arm64|aarch64)
        OS_ARCH=linux_arm64
        PLATFORM_FLAG="--platform linux/amd64"
        ;;
      *)
        unsupported_arch $OS $ARCH
        ;;
    esac
    ;;
  *)
    unsupported_arch $OS $ARCH
    ;;
esac


function build_maven() {
    echo
    echo "Building Spring Boot App..."
    echo
    mvn clean verify
    echo
    echo "Done! Maven build successful"
    echo
}

function build_docker_images() {
    local arch=$1
    local platform_flag=$2
    echo
    echo "Building docker images on $archqq"
    echo
    docker build $platform_flag -t $REPOSITORY-graceful:$TAG . -f Dockerfile
    docker build $platform_flag -t $REPOSITORY-non-graceful:$TAG . -f Dockerfile-non-graceful
    docker build $platform_flag -t $REPOSITORY-graceful-dumb-init:$TAG . -f Dockerfile-graceful-dumb-init
    echo
    echo "Done! Docker images successfully created on $arch"
    echo
}



build_maven
build_docker_images "$OS_ARCH" "$PLATFORM_FLAG"
