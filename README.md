## Build
```shell
# upload to data dir
# build image
./build.sh
# write to disk
dd if=./live-image-amd64.hybrid.iso of=/dev/sdb bs=64M conv=fsync status=progress
```

## Post Install
```shell
# bootstrap
/data/user-bootstrap.sh
sudo passwd root

# network
sudo echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
sudo vim /etc/network/interfaces.d/0100-static-ip

# ime
fcitx5-config-qt

# misc
# switch konsole profile
# install vscode recommended extensions

```
