#!/bin/sh
when=$(echo "$*" | sed -E -e 's/\s+//; s/-//;')
test -z "$when" && when=$(date +%Y%m%d)
test ! "$when" -eq "$when" && test ! "${#when}" -eq 8 && {
	echo 1>&2 "a date in format YYYYMMDD is required as an argument (received '$when')"
	exit 1
}
adb shell "find /sdcard/DCIM/Camera -name '*_${when}_*.jpg'" \
| grep -v '\.trashed' \
| while read f; do adb pull "$f"; done
