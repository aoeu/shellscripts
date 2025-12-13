#!/bin/sh
# Some programs provide an encoded file URI as an arg,
# others provide a filepath with an extra leading slash.
invisibleSpace="$(printf '\u200b')"
d="$(/sbin/sed -e 's|^file:/||' -e 's|^//|/|' -e 's/%20/ /g; s/%5B/[/g; s/%5D/]/g;' -e "s/\%E2\%80\%8B/${invisibleSpace}/g" <<< "$1")"
/sbin/kitty --directory "$d"
