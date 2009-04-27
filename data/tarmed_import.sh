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

URL='http://www.tarmedsuisse.ch/fileadmin/media/Dateien/Browser_V_1.06/TARMED_Database_V01.06.zip'

NAME="tarmed"

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
	for cmd in wget mdb-schema mdb-tables mdb-export sqlite3 ; do
		check_cmd $cmd
	done
}

# Download MS Access DB
function get() {
local url="${1:-$URL}"
local output="${2:-$NAME.zip}"
	wget --no-verbose "$url" --output-document "$output"
	unzip "$output"
	mv TARMED_Database_V01.06.mdb $NAME.mdb
}

# Create sqlite3 db
function convert() {
local input="${1:-$NAME.mdb}"
local output="${2:-$NAME.sqlite3}"

	./tarmed_convert.sh --sqlite3 "$input" | sqlite3 "$output"

	# Create links
	ln -fs "../data/$output" ../db/tarmed_development.sqlite3
	ln -fs "../data/$output" ../db/tarmed_production.sqlite3
	ln -fs "../data/$output" ../db/tarmed_test.sqlite3
}

function import() {
local input="${2:-$NAME.csv}"

	# Import as TariffItems
	echo "Tarmed::Base.import_all(true)" | ../script/console
}

# Cleanup
function cleanup() {
	rm "$NAME.zip"
	rm "$NAME.mdb"
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

