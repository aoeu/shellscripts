#!/bin/sh
# Some programs provide an encoded file URI as an arg,
# others provide a filepath with an extra leading slash.
/sbin/kitty --directory "$(/sbin/sed -e "s|^file:/||" -e 's|^//|/|' -e "s/+/ /g; s/%20/ /g" <<< "$1")"
