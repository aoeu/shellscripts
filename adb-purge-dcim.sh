#!/bin/sh
# Usage: `adb-purge-dcim *.jpg` for files pulled with `adb-pull-dcim`
for f in $@; do
	adb shell rm /sdcard/DCIM/Camera/"$f"
done
