#!/bin/sh

processID="$$"
nextFiles="/tmp/next-$processID"
prevFiles="/tmp/prev-$processID"
touch "$prevFiles" "$nextFiles"

currFiles="file-list.csv"
test -e "$currFiles" && cp "$currFiles" "$prevFiles"
stat --format '%n,%y' * > "$nextFiles"

cat "$prevFiles" "$nextFiles" | sort | uniq | grep -v "$currFiles" > "$currFiles" && \
	rm "$prevFiles" "$nextFiles"
