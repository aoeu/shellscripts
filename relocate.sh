#!/bin/sh
# relocate.sh moves a list of files to a provided directory.
# ln -s ~/dev/shellscripts/relocate.sh ~/bin/reloc
filelist="$1"
destination="$2"

test ! -e "$filelist" && {
	echo 1>&2 "first argument must be a valid file contatining newline separated list of other valid files"
	exit 1
}

test "" = "$destination" && {
	d=$(echo "$filelist" | sed 's/\.txt$//g')
	mkdir "$d" || {
		echo 1>&2 "no destination directory provided as second argument and could not automatically create directory '$d'"
		exit 1
	}
	destination="$d"
}

test ! -d "$destination" && {
	echo 1>&2 "second arument must be a valid directory to relocate files into"
	exit 1
}

for f in $(cat "$filelist")
do
	test ! -e "$f" && {
		echo 1>&2 "the file list '$filelist' contained a non-existent file '$f'"
		continue
	}
	mv "$f" "${destination}/${f}"
done
