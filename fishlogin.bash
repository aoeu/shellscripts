#!/usr/bin/env bash

s='/usr/local/bin/fishlogin'
test $# -eq 1 && test "$1" = "-i" && \
	echo "installing to $s then adding to /etc/shells then running chsh, all with sudo" && \
	[[ "$(read -e -p 'OK? [y/N]> '; echo $REPLY)" == [Yy]* ]] && \
	sudo cp $(readlink -f $0) "$s" && \
	sudo sh -c "echo ${s} >> /etc/shells" && \
	sudo chsh -s "$s" $USER

exec /usr/bin/env fish $*
