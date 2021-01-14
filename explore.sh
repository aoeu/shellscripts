#!/bin/sh
filepath="$1"
test -z "$filepath" && filepath="$HOME"
test ! -d "$filepath" && \
	echo "the supplied filepath is not a valid directory: $filepath" && \
	exit 1
caja --no-desktop "$filepath"
