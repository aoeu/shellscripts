#!/bin/sh
# scrape-woot.sh downloads woot.com's musical instruments page, scrapes the
# items that are not sold out, converts the subsequent unordered list into a
# table, and then outputs the table on a bare HTML page.
#
# Each image for each product will link to the corresponding woot.com page.
#
# alias open='xdg-open' # For linux, not macOS
# alias woot='scrape-woot.sh > /tmp/woot.html && open /tmp/woot.html'

echoerr() {
	echo "$*" 1>&2
}

test "" = $(command -v curl) && \
	echoerr "curl is required and was not found (hint: pacman -S curl )" && \
	exit 1

test "" = $(command -v pup) && \
	echoerr "pup is required and was not found" && \
	echoerr "(hint: go install github.com/ericchiang/pup@latest )" && \
	exit 1

url='https://www.woot.com/category/electronics/dj-equipment-musical-instruments'
resp=$(curl -sSL -A google "$url")
list=$(pup "ul.product-grid li:not(.soldout)" <<< "$resp")
table=$(sed 's/<li/<tr/g; s/li>/tr>/g; s/span/td/g; s#.*\(<img.*>\)# \1<\/td>#g; s#\(<a href\)#<td class="image">\1#g' <<< "$list")

cat << END
<!DOCTYPE html>
<style>
td.title { width: 20%; }
td.image { width: 05%; }
</style>
<table cellpadding="10">
$table
</table>
END
