## Build
* `./build.sh`
* `dd if=./live-image-amd64.hybrid.iso of=/dev/sdb bs=64M conv=fsync status=progress`

## Post Install
* `/data/user-bootstrap.sh`
* `sudo passwd root`
