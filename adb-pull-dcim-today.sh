#!/bin/sh
adb shell "find /sdcard/DCIM/Camera -name '*_$(date +%Y%m%d)_*.jpg'" \
| while read f; do adb pull "$f"; done
