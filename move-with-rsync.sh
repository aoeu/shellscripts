#!/bin/sh
set -o errexit

error() { echo >&2 "$@"; }

test "$#" -ne 2 && {
	error "usage: $0 <source> <target>"
	exit 1
}

# Remove trailing slashes that alter rsync behavior (which are readily included by modern shells).
source="${1%/}"
test -z "$source" && {
	error "source cannot be empty"
	exit 1
}
test ! -e "$source" && {
	error "source '$source' does not exist (nothing to move)"
	exit 1
}

target="${2%/}"
test -z "$target" && {
	error "target cannot be empty"
	exit 1
}
sourceBasename=$(basename "$source")
test ! -d "$target" && {
	error "target directory '$target' (to place '$sourceBasename' into) does not exist"
	exit 1
}
test -e "$target/$sourceBasename" && {
	error "'$sourceBasename' already exists in target directory '$target'"
	exit 1
}
targetBasename=$(basename "$target")
test -d "$source" && test "$targetBasename" = "$sourceBasename" && {
	error "source directory '$sourceBasename' is same as target directory"
	error "which would create nesting: '$target/$sourceBasename'"
	exit 1
}

test $(stat --format %D "$source") \
   = $(stat --format %D "$(dirname "$target")") && {
	error "source '$source' and target '$target' are on same device, use mv instead"
	exit 1
}

rsync --remove-source-files --info=progress2 --archive --verbose "$source" "$target/" && \
	test -d "$source" && \
	find "$source" -type d -empty -delete
	# "--remove-source-files" is quite literal and rsync is incapable of
	# cleaning up empty directories, so we must do so ourselves.
