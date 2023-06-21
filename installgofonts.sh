#!/bin/sh
echo 'This "script" is an informal collection of commands manually run on Arch Linux, use it as reference only.' && exit 1 
# https://go.dev/blog/go-fonts 
# TODO(aoeu): Formalize or put commands in separate files for other OSes.
git clone https://go.googlesource.com/image /tmp/image
sudo mkdir -p /usr/local/share/fonts/ttf/Go
sudo cp /tmp/image/font/gofont/ttfs/*.ttf /usr/local/share/fonts/ttf/Go/
fc-cache # TODO(aoeu): Is sudo needed?
fontsrv -p . | grep '^Go' # TODO(aoeu): Check for plan9port tools.
