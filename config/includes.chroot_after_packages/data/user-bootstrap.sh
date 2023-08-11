#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

bashrc_hint='#### devos user bootstrap ####'
if ! grep -q "$bashrc_hint" $HOME/.bashrc; then
    echo "change $HOME/.bashrc"
    printf "\n\n$bashrc_hint" >> $HOME/.bashrc
    printf 'shopt -q login_shell || . /etc/profile.d/git-prompt.sh' >> $HOME/.bashrc
    printf 'export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH' >> $HOME/.bashrc
fi
