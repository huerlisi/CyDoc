#!/bin/bash

#  Copyright 2009-2010 Simon Hürlimann <simon.huerlimann@cyt.ch>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

URL='http://www.forum-datenaustausch.ch/'

# Download MS Excel
function get() {
local url="${1:-$URL}"
local output="${2:-$NAME.xls}"
	wget --no-verbose "$url" --output-document "$output"
}

function convert() {
local input="${1:-$NAME.xls}"
local output="${2:-$NAME.csv}"

	xls2csv "$input" >"$output"
}

function import() {
local input="${2:-$NAME.csv}"

	# Import
	echo "Tarifcodes::Base.import_all(true)" | ../script/console
}

function cleanup() {
	rm "$NAME.xls"
	rm "$NAME.csv"
}

function list() {
	echo "tarif_code" "20091214"
#	echo "response_code" "20081027"
#	echo "status_and_validity" "20060901"
}

function import_all() {
	list | while read ident version ; do
		NAME="${ident}_${version}"
		get "${URL}${NAME}.xls"
		convert
		import
		cleanup
	done
}


# Main
# ====
function main() {
	import_all
}

if [ $# == 0 ] ; then
	main
else
	$@
fi
