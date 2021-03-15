#!/bin/sh
function formatWithGNUfmt {
	fmt -p '//' -w 80
}

function formatWithBSDfmt {
	sed -e 's#^//##' -e 's#^ ##' | fmt -w 77 | sed -e 's#^#// #' -e 's# $##'
}

function removeFinalNewlineForAcme {
	perl -p -e 'chomp if eof'
}

test $(echo $OSTYPE | sed 's/[0-9]//g') = 'darwin' \
	&& format=formatWithBSDfmt \
	|| format=formatWithGNUfmt

test "$*" = "" &&  $format | removeFinalNewlineForAcme || echo "$*" | $format
