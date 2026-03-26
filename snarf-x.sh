#!/bin/sh
test "" = "$1" && {
	xclip -selection clipboard
	exit 0
}
test -d "$1" && {
	realpath "$1" | xclip -selection clipboard
	exit 0
}
test -f "$1" && {
	xclip -selection clipboard < "$1"
	exit 0
}
echo "$@" | xclip -selection clipboard
