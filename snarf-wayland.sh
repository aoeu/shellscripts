#!/bin/sh
test "" = "$1" && {
	wl-copy
	exit 0
}
test -d "$1" && {
	realpath "$1" | wl-copy
	exit 0
}
test -f "$1" && {
	wl-copy < "$1"
	exit 0
}
wl-copy "$@"
