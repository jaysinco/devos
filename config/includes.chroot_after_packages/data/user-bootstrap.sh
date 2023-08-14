#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

bashrc_hint='#### devos user bootstrap ####'
if ! grep -q "$bashrc_hint" $HOME/.bashrc; then
    echo "-- change $HOME/.bashrc"
    {
        echo
        echo
        echo "$bashrc_hint"
        echo "shopt -q login_shell || . /etc/profile.d/git-prompt.sh"
        echo "export EDITOR=/usr/bin/nvim"
        echo 'export PATH=/usr/local/sbin:/usr/sbin:/sbin:~/.local/bin:$PATH'
        echo "alias code='code --enable-features=WaylandWindowDecorations --ozone-platform=wayland'"
        echo
    } >> $HOME/.bashrc
fi

if [[ ! $(type -P "conan") ]]; then
    echo "-- install conan"
    pip3 install conan==1.52 -i https://pypi.tuna.tsinghua.edu.cn/simple -q --break-system-packages
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "-- install ssh key"
    mkdir -p $HOME/.ssh
    cp /data/id_rsa /data/id_rsa.pub $HOME/.ssh/
    chmod 700 $HOME/.ssh
    chmod 600 $HOME/.ssh/id_rsa
    chmod 644 $HOME/.ssh/id_rsa.pub
fi

nvim_data_dir=$HOME/.local/share/nvim
if [ ! -d "$nvim_data_dir/site" ]; then
    echo "-- install nvim data"
    mkdir -p $nvim_data_dir
    unzip -q /data/nvim-data-site-v0.7.2-linux-x86_64.zip -d $nvim_data_dir
fi

konsole_data_dir=$HOME/.local/share/konsole
if [ ! -d "$konsole_data_dir/sinco.profile" ]; then
    echo "-- install konsole data"
    mkdir -p $konsole_data_dir
    cp /etc/devos/konsole/* $konsole_data_dir
fi

vscode_config_dir=$HOME/.config/Code/User
if [ ! -d "$vscode_config_dir/extensions.json" ]; then
    echo "-- install vscode config"
    mkdir -p $vscode_config_dir
    cp /etc/devos/vscode/* $vscode_config_dir
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
clone_repo $HOME/atlas jaysinco/atlas.git master
clone_repo $HOME/devos jaysinco/devos.git master
