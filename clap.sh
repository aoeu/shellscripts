#!/bin/sh

echoerr() {
        echo $* 2>&1
}

input="$*"
test "$input" = "" && \
        echoerr "usage: $0 'a phrase to capitalize and interlace with hand-claps " && \
        exit 1

input=$(echo "$input" | tr '[a-z]' '[A-Z]' | sed -e 's/\s+/ /g')
output=""
for s in $(echo $input); do
        output="$output$s 👏 "
done
echo "$output" | sed 's/ $//'
