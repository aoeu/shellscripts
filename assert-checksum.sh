#!/bin/sh

echoerr() {
	echo $* 1>&2
}

expected="$1"
test -z "$expected" && \
	echoerr "first argument must be the expected checksum" && \
	exit 1

filepath="$2"
test ! -e "$filepath" && \
	echoerr "second argument must be the file to run checksum algorithm on" && \
	exit 1

actual=$( md5sum "$filepath" | cut -d ' ' -f1 )

test "$expected" != "$actual" && \
	echoerr "expected $expected but actual checksum was $actual" && \
	exit 1

exit 0
