#!/bin/sh
set -e

echoerr() {
	echo $* 1>&2
}

tmpDir="/tmp/$$"

zipFile="$1"

test -z "$zipFile" && echoerr "usage: $0 <zip_file_name>" && exit 1
test ! -f "$zipFile" && echoerr "'$zipFile' does not appear to be a regular file, exiting" && exit 1
ext=$(echo $zipFile | sed -E 's/^.*\.([a-zA-Z]{3})$/\1/')
test ! "zip" = "$ext" && echoerr "$zipFile must end with a .zip extension" && exit 1

noExt=$(echo $zipFile | sed -E 's/\.[a-zA-Z]{3}$//')

targetDir="$noExt"
test -d "$targetDir" && echoerr "'$targetDir' already exists as a directory, exiting" && exit 1

mkdir "$targetDir"

workDir="$tmpDir/$noExt"

mkdir -p "$workDir"

unzip -q -d "$workDir" "$zipFile"

contents=$(ls --almost-all -1 "$workDir")

toMove="$workDir"

# Was all the content of the zip file under a single dir, then that single dir was zipped?
# Then lets move what is in the single dir, not the single dir itself.
test 1 = $(echo "$contents" | wc -l) && test -d "$workDir/$contents" && toMove="$workDir/$contents"

for f in $(ls --almost-all -1 "$toMove"); do
	mv "$toMove/$f" $targetDir
done

# If it existed, remove the single dir that all the "real" contents (now relocated) of the zip file was in.
test 1 = $(echo $contents | wc -l) && test -d "$workDir"/"$contents" && rmdir "$workDir"/"$contents"
rmdir "$workDir"
rmdir "$tmpDir"
