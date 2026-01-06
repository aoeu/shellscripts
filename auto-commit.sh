#!/bin/sh
# debug protip: 33,$s/git/GIT_TRACE=1 git/g		33,$s/GIT_TRACE=1 //g
# Known limitations: A subsequent MOVED_TO event does not occur after a MOVED_FROM if
# a file is moved (with mv) out of the watched repository, which this script cannot
# realisitically account for, so simply don't do that (and cp with a subsquent rm instead).
set -o errexit
test ! -d '.git' && {
	echo 2>&1 'not a git repository'
	exit 1
}
pid=$(pgrep "${0#./}") && grep --invert-match --quiet "$$" <<< "$pid" && {
        echo 2>&1 "an instance of '${0#./}' is already running"
        exit 1 # TODO(aoeu): support running one instance per repo, not per system
}
printf \
'Until stopped, this script will silently and automatically git commit
any file edit, rename, creation, or deletion as it occurs to the 
filesystem both in and beneath the current directory.

We good with that? (y/N)\n'
read -p	'> ' response
(test 'y' = "$response" && echo '🖏  Press Ctrl+c to exit.') || exit
message=''
inotifywait \
	--quiet \
	--monitor \
	--recursive \
	--event create,delete,move,close_write \
	--exclude "$0|\./\.git|"'\.git/|\.swp$|~$|\.tmp$|(^|/)[0-9]+$' \
	--format '%e %w%f' \
	'.' \
| while read event filepath
do
	case $event in
	*,IS_DIR) continue ;;
	CREATE|CLOSE_WRITE)
		test -f "$filepath" && git add "$filepath" && message='change of'
	;;
	MOVED_FROM)
		test ! -f "$filepath" && git rm --quiet "$filepath" && {
			message="renaming of '${filepath#./}' to"
			continue
		}
	;;
	MOVED_TO) # occurs immediately after MOVED_FROM event
		test -f "$filepath" && git add "$filepath"
	;;
	DELETE)
		test ! -f "$filepath" && git rm --quiet "$filepath" && message='deletion of'
	;;
	esac
	errorStatusIfIndexDirty='git diff-index --quiet --cached HEAD'
	test -z "$message" || eval "$errorStatusIfIndexDirty" || {
		git commit --quiet --message "Auto-commit $message '${filepath#./}'"
		message=''
	}
done
