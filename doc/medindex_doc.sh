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

URL="https://index.ws.e-mediat.net/INT_medindex/schema"

function get() {
local model="$1"
local direction="${2:-out}"

	local user
	local password

	# Guess or ask for credentials
	if [ -n "$MEDINDEX_USER" ] ; then
		user="$MEDINDEX_USER"
	else
		read -r -p "User: " user
	fi
	
	if [ -n "$MEDINDEX_PASSWORD" ] ; then
		password="$MEDINDEX_PASSWORD"
	else
		read -s -r -p "Password: " password
	fi

	# Dowload XSD
	mkdir -p "medindex"
 	wget --no-verbose --user "$user" --password "$password" --no-check-certificate "$URL/DownloadMedindex${model}_${direction}.xsd" -O "medindex/${model}_${direction}.xsd"
}

function list() {
	echo "Article"
	echo "Article_Wholesaler"
	echo "Brevier"
	echo "Company"
	echo "Codex"
	echo "Code"
	echo "Insurance"
	echo "Interaction"
	echo "Kompendium"
	echo "Kompendium_Product"
	echo "Physician"
	echo "Product"
	echo "Substance"
	echo "Wholesaler"
}

function get_all() {
	for model in $(list) ; do
		get $model 'in'
		get $model 'out'
	done
}

# Main
$@
