#!/bin/sh
function format {
	fmt -p '//' -w 80
}
function removeFinalNewlineForAcme {
	perl -p -e 'chomp if eof'
}
test "$*" = "" &&  format | removeFinalNewlineForAcme || echo "$*" | format
