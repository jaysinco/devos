#!/bin/bash

set -e

# flags

do_clean=0
do_build_image=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -h)
            echo
            echo "Usage: build.sh [options] [targets]"
            echo
            echo "Build Options:"
            echo "  -c           clean before build"
            echo "  -h           print command line options"
            echo
            echo "Build Targets:" 
            echo "  image        build image"
            echo
            exit 0
            ;;
         -c) do_clean=1 && shift ;;
      image) do_build_image=1 && shift ;;
          *) echo "invalid argument: $1" && exit 1 ;;
    esac
done

if [ $do_build_image -eq 0 -a $do_build_image -eq 0 ]; then
    do_clean=1
    do_build_image=1
fi

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function setup_func() {
    git clone https://salsa.debian.org/live-team/live-build.git
    cd live-build
    dpkg-buildpackage -b -uc -us
    dpkg -i ../live-build_20230502_all.deb
}

function clean_func() {
    sudo lb clean
}

function build_image_func() {
    lb config \
    && \
    sudo lb build
}

pushd $script_dir \
&& \
if [ $do_clean -eq 1 ]; then
    clean_func
fi \
&& \
if [ $do_build_image -eq 1 ]; then
    build_image_func
fi