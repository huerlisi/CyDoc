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

URL='https://match.postmail.ch/download?id=10000&tid=10'

NAME="postal_code"

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
	for cmd in wget unzip recode; do
		check_cmd $cmd
	done
}

# Download
function get() {
local url="${1:-$URL}"
local output="${2:-$NAME.zip}"

        wget --no-check-certificate --no-verbose "$url" --output-document "$output"
        unzip "$output"
        mv plz_l_*.txt $NAME.csv
}

function convert() {
local input="${1:-$NAME.csv}"

	recode ISO-8859-15/CR-LF..UTF8 "$input"
}

function import() {
local input="${2:-$NAME.csv}"

	# Import
	echo "PostalCodes::Import; PostalCode.import_all; nil" | ../script/console
}

function cleanup() {
	rm "$NAME.zip" "$NAME.csv"
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
