#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

bashrc_hint='#### devos user bootstrap ####'
if ! grep -q "$bashrc_hint" $HOME/.bashrc; then
    echo "-- change $HOME/.bashrc"
    printf "\n\n$bashrc_hint\n" >> $HOME/.bashrc
    printf 'shopt -q login_shell || . /etc/profile.d/git-prompt.sh\n' >> $HOME/.bashrc
    printf 'export PATH=/usr/local/sbin:/usr/sbin:/sbin:~/.local/bin:$PATH\n' >> $HOME/.bashrc
fi

if [[ ! $(type -P "conan") ]]; then
    echo "-- install conan"
    pip3 install conan==1.52 -i https://pypi.tuna.tsinghua.edu.cn/simple --break-system-packages
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "-- copy ssh key"
    mkdir -p $HOME/.ssh
    cp /data/id_rsa /data/id_rsa.pub $HOME/.ssh/
    chmod 700 $HOME/.ssh
    chmod 600 $HOME/.ssh/id_rsa
    chmod 644 $HOME/.ssh/id_rsa.pub
fi

function clone_repo() {
    mkdir -p "$1" 
    cd "$1" 
    if [ ! -d "$1/.git" ]; then
        echo "-- git clone $2 -b $3" \
        && git init \
        && git remote add origin git@gitee.com:$2 \
        && git fetch \
        && git checkout origin/$3 -b $3 \
        && git remote add backup git@github.com:$2
    fi
    git config user.name jaysinco
    git config user.email jaysinco@163.com
}

clone_repo $HOME/.config/nvim jaysinco/nvim.git master
