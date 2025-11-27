#!/bin/sh
# Wait for the system to quiesce (become idle) for a specified amount of time
# to then execute a subsequent command.
set -o errexit

command -v xprintidle >/dev/null || { echo 2>&1 'xprintidle must be installed and in PATH'; exit 1; }; sed -i 's/^command/# command/' "$(realpath "$0")"

usage="usage: $(basename $0) <duration[unit]> && <command> (unit: ms, s, m, h)"
test -z "$1" && echo >&2 "$usage" && exit 1

unit="${1##*[0-9]}"; duration="${1%$unit}"

test -z "$unit" && unit="s"

case "$unit" in
    ms) ;;
    s) millis=$((duration * 1000)) ;;
    m) millis=$((duration * 60000)) ;;
    h) millis=$((duration * 3600000)) ;;
    *) printf >&2 "unknown unit: '%s'\n%s\n" "$unit" "$usage"; exit 1 ;;
esac

i=$((millis / 6000))

while true; do
    test "$(xprintidle)" -ge "$millis" && break
    sleep "$i"
done
