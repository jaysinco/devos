#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ ! -f "$HOME/.bash_profile" ]; then
    echo "-- install $HOME/.bash_profile"
    cp /etc/devos/.bash_profile $HOME
fi

bashrc_hint='#### devos user bootstrap ####'
if ! grep -q "$bashrc_hint" $HOME/.bashrc; then
    echo "-- change $HOME/.bashrc"
    {
        echo
        echo
        echo "$bashrc_hint"
        echo ". /etc/profile.d/git-prompt.sh"
        echo "export EDITOR=/usr/bin/nvim"
        echo 'export PATH=/usr/local/sbin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/flutter/bin:$PATH'
        echo 'export XDG_SESSION_TYPE=wayland'
        echo 'export GDK_BACKEND=wayland'
        echo 'export GDK_DPI_SCALE=1.2'
        echo 'export GTK_IM_MODULE=fcitx'
        echo 'export QT_QPA_PLATFORM=wayland'
        echo 'export QT_IM_MODULE=fcitx'
        echo 'export XMODIFIERS=@im=fcitx'
        echo 'export SDL_IM_MODULE=fcitx'
        echo 'export SINCO_CONAN_SRCDIR=/data/src'
        echo 'export PUB_HOSTED_URL=https://pub.flutter-io.cn'
        echo 'export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn'
        echo "alias code='code --enable-features=WaylandWindowDecorations --ozone-platform=wayland'"
        echo
    } >> $HOME/.bashrc
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "-- install ssh key"
    mkdir -p $HOME/.ssh
    cp /data/id_rsa /data/id_rsa.pub $HOME/.ssh/
    chmod 700 $HOME/.ssh
    chmod 600 $HOME/.ssh/id_rsa
    chmod 644 $HOME/.ssh/id_rsa.pub
fi

if [ ! -f "$HOME/.local/bin/conan" ]; then
    echo "-- install conan"
    pip3 install conan==1.52 -i https://pypi.tuna.tsinghua.edu.cn/simple \
        --quiet --no-warn-script-location --break-system-packages
fi

if [ ! -f "/usr/bin/ct-ng" ]; then
    echo "-- install crosstool-ng"
    sudo apt-get install gperf bison flex texinfo help2man libncurses5-dev \
        autoconf automake libtool libtool-bin gawk meson
    tar xf /data/crosstool-ng-1.26.0.tar.xz --directory=$HOME
    pushd $HOME/crosstool-ng-1.26.0
    ./configure --prefix=/usr && make && sudo make install
    popd
    rm -rf $HOME/crosstool-ng-1.26.0
fi

nvim_data_dir=$HOME/.local/share/nvim
if [ ! -d "$nvim_data_dir/site" ]; then
    echo "-- install nvim data"
    mkdir -p $nvim_data_dir
    unzip -q /data/nvim-data-site-v0.7.2-linux-x86_64.zip -d $nvim_data_dir
fi

konsole_data_dir=$HOME/.local/share/konsole
if [ ! -f "$konsole_data_dir/sinco.profile" ]; then
    echo "-- install konsole data"
    mkdir -p $konsole_data_dir
    cp /etc/devos/konsole/* $konsole_data_dir
fi

vscode_config_dir=$HOME/.config/Code/User
if [ ! -f "$vscode_config_dir/keybindings.json" ]; then
    echo "-- install vscode config"
    mkdir -p $vscode_config_dir
    cp /etc/devos/vscode/* $vscode_config_dir
fi

mkdir -p $HOME/temp

function clone_repo() {
    mkdir -p "$1"
    cd "$1"
    if [ ! -d "$1/.git" ]; then
        echo "-- git clone $2 -b $3" \
        && git init \
        && git remote add origin git@gitee.com:$2 \
        && git fetch \
        && git checkout $3 -b $4 \
        && git remote add backup git@github.com:$2
    fi
    git config user.name jaysinco
    git config user.email jaysinco@163.com
}

# clone_repo $HOME/flutter jaysinco/flutter.git "tags/3.10.6" "3.10.6"
clone_repo $HOME/.config/nvim jaysinco/nvim.git origin/master master
clone_repo $HOME/atlas jaysinco/atlas.git origin/master master
clone_repo $HOME/devos jaysinco/devos.git origin/master master
clone_repo $HOME/cpptools jaysinco/cpptools.git origin/master master
