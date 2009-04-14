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

URL="http://www.trustx.ch/trustx-praxis/documents/Test_Rechnungen.zip"

function get() {
	mkdir -p "trustx"
 	pushd . >/dev/null
 	cd trustx
 		wget --no-verbose "$URL" -O Test_Rechnungen.zip
		unzip Test_Rechnungen.zip
	popd >/dev/null
}


# Main
$@
