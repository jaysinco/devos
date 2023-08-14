#!/bin/bash

set -e

# flags

do_build_image=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -h)
            echo
            echo "Usage: build.sh [options] [targets]"
            echo
            echo "Build Options:"
            echo "  -h           print command line options"
            echo
            echo "Build Targets:"
            echo "  image        build image"
            echo
            exit 0
            ;;
      image) do_build_image=1 && shift ;;
          *) echo "invalid argument: $1" && exit 1 ;;
    esac
done

if [ $do_build_image -eq 0 -a $do_build_image -eq 0 ]; then
    do_build_image=1
fi

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# function install_live_build() {
#     git clone https://salsa.debian.org/live-team/live-build.git
#     cd live-build
#     dpkg-buildpackage -b -uc -us
#     dpkg -i ../live-build_20230502_all.deb
# }

function build_image_func() {
    sudo lb clean \
    && \
    lb config \
    && \
    find $script_dir/config/includes.chroot_after_packages/data/ \
        -name "*.deb" -exec mv -f {} $script_dir/config/packages.chroot/ \; \
    && \
    sudo lb build \
    && \
    sudo chroot $script_dir/chroot \
        apt list --installed > $script_dir/apt.installed 2>/dev/null
}

pushd $script_dir \
&& \
if [ $do_build_image -eq 1 ]; then
    build_image_func
fi
