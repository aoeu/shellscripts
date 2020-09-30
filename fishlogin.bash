#!/usr/bin/env bash

linkread() {
	/usr/bin/env python -c 'import os; import sys; print os.path.realpath(sys.argv[1])' $1
}

s='/usr/local/bin/fishlogin'
test $# -eq 1 && test "$1" = "-i" && \
	echo "installing to $s then adding to /etc/shells then running chsh, all with sudo" && \
	[[ "$(read -e -p 'OK? [y/N]> '; echo $REPLY)" == [Yy]* ]] && \
	sudo cp $(linkread $0) "$s" && \
	sudo sh -c "echo ${s} >> /etc/shells" && \
	sudo chsh -s "$s" $USER

exec /usr/bin/env fish $*
