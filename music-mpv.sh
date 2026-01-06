#!/bin/sh
args="$@"

# If a playlist file is specified, automatically add the flag for it if not already present.
test $# -eq 1 && case "$1" in *.m3u) case "$1" in -playlist=*) ;; *) set -- "-playlist=$1";; esac;; esac && args="$1"

test -z "$args" && {
	firstPlaylistFile=$(ls -1 | grep '\.m3u$' | head -1) 
	test ! -z "$firstPlaylistFile" && args="-playlist=$firstPlaylistFile"
}

test -z "$args" && {
	firstAudioFile=$(ls -1 | grep -E '\.(flac|mp3|opus)$' | head -1) # Add wav, aif, aac, etc. if needed..
	args="$firstAudioFile"
}

test -z "$args" && {
	echo 2>&1 'a m3u, flac, mp3 or opus file must exist in the directory (the first is used), or otherwise provide arguments'
	exit 1
}

size=2160x1440
mpv \
--gapless-audio=yes \
--input-commands="script-binding select/select-playlist" \
--lavfi-complex="[aid1]asplit[ao][a]; [a]showcqt=s=$size[vo]" \
--geometry=$size \
--player-operation-mode=pseudo-gui \
--script-opts=osc-visibility=always,osc-scalewindowed=2,osc-scalefullscreen=2,osc-layout=bottombar \
--osd-level=3 \
--osd-duration=100000 \
--osd-bar-align-y=0.80 \
"$args"
