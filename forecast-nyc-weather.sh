#!/bin/sh

echoerr() {
	echo 2>&1 $*
}

test "" = "$(command -v curl)" && \
	echoerr 'curl is required and not found' && \
	exit 1

test "" = "$(command -v jq)" && \
	echoerr 'jq is required and not found' && \
	exit 1

# Using your latlong, Get the forecast URL from the 'properties.forecast' field of:
# 	https://api.weather.gov/points/40.7,-73.93
url='https://api.weather.gov/gridpoints/OKX/36,35/forecast'
forecast=$(curl --silent --show-error "$url")

delim='"\n\t• "'
mapArgs=".name + $delim + \
	(.temperature|tostring) + \"°\" + .temperatureUnit + $delim + \
	 .shortForecast + $delim + \
	 .detailedForecast + \"\n\""
filter=".properties.periods[0:4]|map(${mapArgs})|.[]"

jq --raw-output "$filter" <<< "$forecast" | fmt --split-only --width 80
