#!/bin/sh
test "" = "$1" && {
	xclip -selection clipboard "$@"
	exit 0 
}
test ! -f "$1" && {
	echo 1>&2 "argument '$1' was provided that is not an existant file"
	exit 1
}
cat "$1" | xclip -selection clipboard
