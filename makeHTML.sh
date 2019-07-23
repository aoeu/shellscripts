#!/bin/sh

# This script converts a markdown file in the current directory to an
# index.html file when the markdown file is determined to have been changed
# since the last time this script ran.  This script is intended to be used
# with an HTTP server to serve the index.html file from the current directory
# and in conjunction with the Watch command of acme editor:
# https://github.com/aoeu/acme/cmd/Watch

s="A markdown generator not found in PATH, exiting.
Try running: 'go get -u github.com/russross/blackfriday-tool'
Then retry running: '$0 $*'"

which blackfriday-tool || \
	 { echo 1>&2 "$s"; exit 1; }

workDir="/tmp"

filename="$1"
test -z "$filename" && \
	echo 1>&2 "a markdown filename is needed" && \
		exit 1

md5Filename="${workDir}/${filename}_md5sum"
test ! -e "$md5Filename" && md5sum "$filename" > "$md5Filename"

current=$(md5sum "$filename")
previous=$(cat "$md5Filename")

( test ! "$current" = "$previous" && \
	echo "$current" > "$md5Filename" && \
		blackfriday-tool "$filename" index.html )  || \
			exit 0
