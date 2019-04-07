#!/bin/sh
test ! $(which rg) && echo 2>&1 "ripgrep (rg) not found: must install rg before running $0" && exit 1

search=$1
replace=$2
dryrun=$3
test -z "$search"  && echo 'usage: $0 <search> <replace>' 1>&2 && exit 1
test -z "$replace" && echo 'usage: $0 <search> <replace>' 1>&2 && exit 1

if [ ! -z $dryrun ]; then
	rg "$search" | sed "s/$search/$replace/g"
else
	rg "$search" -l | xargs sed -i "s/$search/$replace/g"
fi
