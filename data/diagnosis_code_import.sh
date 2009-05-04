#!/bin/bash

#  Copyright 2009 Simon Hürlimann <simon.huerlimann@cyt.ch>
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

URL='http://www.marcmuret.ch/tessinercode0.htm'

NAME="diagnosis_by_contract"

function check_cmd() {
local cmd=$1

	if which $cmd >/dev/null ; then
		echo "Found '$cmd'"
	else
		echo "[ERROR] $cmd not found"
		exit 1
	fi
}

function check() {
	for cmd in wget w3m ; do
		check_cmd $cmd
	done
}

# Download
function get() {
local url="${1:-$URL}"
local output="${2:-$NAME.html}"
	wget --no-verbose "$url" --output-document "$output"
}

function convert() {
local input="${1:-$NAME.html}"
local output="${2:-$NAME.csv}"

	w3m -dump "$input" |
	  egrep '([A-T] [0-9] .*)|([0-9]{2} .*)' |
	  sed 's/^\([A-T]\) /\1/' |
	  sed 's/^\(..\) /\1;/' > "$output"
}

function import() {
local input="${2:-$NAME.csv}"

	# Import as TariffItems
	echo "DiagnosisCodes::Base.import_all(true, :input => '$input')" | ../script/console
}

function cleanup() {
	rm "$NAME.html"
	rm "$NAME.csv"
}


# Main
# ====
function main() {
	check
	get
	convert
	import
	cleanup
}

if [ $# == 0 ] ; then
	main
else
	$1
fi
