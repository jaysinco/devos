#!/bin/bash

set -e

# flags

do_clean=0
do_config=0
do_build_image=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -h)
            echo
            echo "Usage: build.sh [targets]"
            echo
            echo "Build Targets:" 
            echo "  clean        clean up"
            echo "  config       generate configure files"
            echo "  image        build image"
            echo
            exit 0
            ;;
      clean) do_clean=1 && shift ;;
     config) do_config=1 && shift ;;
      image) do_build_image=1 && shift ;;
          *) echo "invalid argument: $1" && exit 1 ;;
    esac
done

function clean_func() {
    echo "I: clean up"
}

function config_func() {
    echo "I: generate configure files"
    lb config \
        --architectures amd64 \
        --distribution bookworm \
        --archive-areas "main contrib non-free non-free-firmware" \
        --mirror-bootstrap https://mirrors.163.com/debian \
        --mirror-chroot https://mirrors.163.com/debian \
        --mirror-chroot-security https://mirrors.163.com/debian-security \
        --mirror-binary https://mirrors.163.com/debian \
        --mirror-binary-security https://mirrors.163.com/debian-security \
        --mirror-debian-installer https://mirrors.163.com/debian \
        --apt-secure false
}

function build_image_func() {
    echo "I: build image"
    sudo lb build
}

if [ $do_clean -eq 1 ]; then
    clean_func
fi \
&& \
if [ $do_config -eq 1 ]; then
    config_func
fi \
&& \
if [ $do_build_image -eq 1 ]; then
    build_image_func
fi