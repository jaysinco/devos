## Build
```shell
# build
## upload data
./build.sh

# write to disk
dd if=./live-image-amd64.hybrid.iso of=/dev/sdb bs=64M conv=fsync status=progress
```

## Post Install
```shell
# required
/data/user-bootstrap.sh
sudo passwd root

# network*
sudo echo 'source /etc/network/interfaces.d/*' > /etc/network/interfaces
sudo vim /etc/network/interfaces.d/0100-static-ip

# keyboard*
fcitx5-config-qt

# misc
xlsclients
```
