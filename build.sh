#!/bin/bash

#set -eu

help() {
    echo "This script builds the Maven project and creates Docker images."
    echo
    echo "Usage $0 <tag>"
    echo "tag: The tag of docker images in the form '1.0.0' or 'latest'"
    echo
}

if [ -z "$1" ]; then
    help
    exit 1
fi

DOCKER_REPOSITORY='k8s-spring-boot-app'
DOCKER_TAG=$1
DOCKER_PLATFORM_FLAG=""
DOCKER_PLATFORM_FLAG_LINUX_AMD64="--platform linux/amd64"

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
  CYGWIN* | MINGW64* | Windows*)
#    if [ $ARCH = "x86_64" ]
#    then
#      OS_ARCH=windows_amd64
#      BIN=crank.exe
#    else
#      unsupported_arch $OS $ARCH
#    fi
    unsupported_arch $OS $ARCH
    ;;
  Darwin)
    case $ARCH in
      x86_64|amd64)
        OS_ARCH=darwin_amd64
        ;;
      arm64)
        OS_ARCH=darwin_arm64
        DOCKER_PLATFORM_FLAG="${DOCKER_PLATFORM_FLAG_LINUX_AMD64}"
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
        DOCKER_PLATFORM_FLAG="${DOCKER_PLATFORM_FLAG_LINUX_AMD64}"
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
    echo "Building Docker images on $arch"
    echo
    docker build $platform_flag -t $DOCKER_REPOSITORY-graceful:$DOCKER_TAG . -f Dockerfile
    docker build $platform_flag -t $DOCKER_REPOSITORY-non-graceful:$DOCKER_TAG . -f Dockerfile-non-graceful
    docker build $platform_flag -t $DOCKER_REPOSITORY-graceful-dumb-init:$DOCKER_TAG . -f Dockerfile-graceful-dumb-init
    echo
    echo "Done! Docker images successfully created on $arch"
    echo
}

build_maven

build_docker_images "$OS_ARCH" "$DOCKER_PLATFORM_FLAG"
