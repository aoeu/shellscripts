#!/bin/sh
test "$*" = "" && fmt -p '//' -w 80 || echo "$*" | fmt -p '//' -w 80
