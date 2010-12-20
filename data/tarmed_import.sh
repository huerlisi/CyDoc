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

set -e

NAME="tarmed"
VERSION="1.07.01"

FILE_NAME="0${VERSION//./_}_TARMED_Database"
URL="http://www.tarmedsuisse.ch/fileadmin/media/Dateien/Browser_V_${VERSION}/$FILE_NAME.zip"

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
	for cmd in wget mdb-schema mdb-tables mdb-export sqlite3 unzip; do
		check_cmd $cmd
	done
}

# Download MS Access DB
function get() {
local url="${1:-$URL}"
local output="${2:-$NAME.zip}"
	wget --no-verbose "$url" --output-document "$output"
	unzip "$output"
	mv $FILE_NAME.mdb $NAME.mdb
}

# Create sqlite3 db
function convert() {
local input="${1:-$NAME.mdb}"
local output="${2:-$NAME.sqlite3}"

	./tarmed_convert.sh --sqlite3 "$input" | sqlite3 "$output"

	# Create links
	ln -fs "../data/$output" ../db/${NAME}_development.sqlite3
	ln -fs "../data/$output" ../db/${NAME}_production.sqlite3
	ln -fs "../data/$output" ../db/${NAME}_test.sqlite3
	ln -fs "../data/$output" ../db/${NAME}_demo.sqlite3
}

function import() {
local input="${2:-$NAME.csv}"

	# Import as TariffItems
	echo "Tarmed::Base.import_all(false)" | ../script/console
}

# Cleanup
function cleanup() {
	rm "$NAME.zip"
	rm "$NAME.mdb"
	rm "$NAME.sqlite3"
	rm "../db/${NAME}_development.sqlite3"
	rm "../db/${NAME}_production.sqlite3"
	rm "../db/${NAME}_test.sqlite3"
	rm "../db/${NAME}_demo.sqlite3"
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

