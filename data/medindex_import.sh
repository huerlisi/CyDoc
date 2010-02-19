#!/bin/bash

#  Copyright 2010 Simon Hürlimann <simon.huerlimann@cyt.ch>
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

URL="https://index.ws.e-mediat.net/medindex"


# Create request XML file
function prepare_request() {
local model="$1"
local from_date="$2"
local filter="$3"

	cat medindex/request_template.xml | sed "s/#{model}/$model/g" | sed "s/#{from_date}/$from_date/g" | sed "s/#{filter}/$filter/g" > medindex/request.xml
}

# Download XML with SOAP
function get() {
local model_ident="$1"
local from_date="$2"
local filter="${3:-A}"

	local user
	local password

	local model="$(echo $model_ident | sed 's/^\([a-z]\)/\u\1/')"
	local output_file="medindex/${model_ident}_$(date +%F).xml"
	local url="$URL/ws_DownloadMedindex$model.asmx"

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

	echo
	echo "Downloading $model"
	
	prepare_request $model $from_date $filter
	wget --no-verbose --header "Content-Type: application/soap+xml" --post-file medindex/request.xml --auth-no-challenge --http-user "$user" --http-password "$password" --output-document "$output_file" "$url"
}

# Show usage
function usage() {
	echo "medindex_import.sh get <model> <from_date> [<filter>]"
}

# Main
if [ $# = 0 ] ; then
	usage
	exit
fi

$@
