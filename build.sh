#!/bin/bash

help() {
    echo "Create docker images for Demo"
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

case `uname -m` in
    "x86_64"*)
        SUPPORTED_ARCHITECTURE="x86_64/amd64"
        echo "You are on $SUPPORTED_ARCHITECTURE"
        PLATFORM_FLAG=""
        ;;
    "arm64"*)
        SUPPORTED_ARCHITECTURE="arm64"
        echo "You are on $SUPPORTED_ARCHITECTURE"
        PLATFORM_FLAG="--platform linux/amd64"
        ;;
    *)
        SUPPORTED_ARCHITECTURE="unknown"
        echo "The build script does not support your system architecture. Please build manually." && exit 1
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
    ARCH=$1
    PLATFORM_FLAG=$2
    echo
    echo "Building docker images on $ARCH"
    echo
    docker build $PLATFORM_FLAG -t $REPOSITORY-graceful:$TAG . -f Dockerfile
    docker build $PLATFORM_FLAG -t $REPOSITORY-non-graceful:$TAG . -f Dockerfile-non-graceful
    docker build $PLATFORM_FLAG -t $REPOSITORY-graceful-dumb-init:$TAG . -f Dockerfile-graceful-dumb-init
    echo
    echo "Done! Docker images successfully created on $ARCH"
    echo
}



build_maven
build_docker_images "$SUPPORTED_ARCHITECTURE" "$PLATFORM_FLAG"
