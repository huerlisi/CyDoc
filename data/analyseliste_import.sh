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

URL='http://www.bag.admin.ch/themen/krankenversicherung/02874/index.html?lang=de&download=M3wBUQCu/8ulmKDu36WenojQ1NTTjaXZnqWfVpzLhmfhnapmmc7Zi6rZnqCkkId4gX1/bKbXrZ2lhtTN34al3p6YrY7P1oah162apo3X1cjYh2+hoJVn6w=='

NAME="analyseliste"

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

	# Import as TariffItems
	echo "Analyseliste::LabTariffItem.import(true)" | ../script/console
}

function cleanup() {
	rm "$NAME.xls"
	rm "$NAME.csv"
}


# Main
# ====
function main() {
	get
	convert
	import
	cleanup
}

main
