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

# Download MS Access DB
wget http://www.tarmedsuisse.ch/fileadmin/media/Dateien/Browser_V_1.06/TARMED_Database_V01.06.zip
unzip TARMED_Database_V01.06.zip

# Create sqlite3 db
./tarmed_convert.sh --sqlite3 TARMED_Database_V01.06.mdb | sqlite3 ../db/tarmed.sqlite3

# Create links
ln -s tarmed.sqlite3 ../db/tarmed_development.sqlite3
ln -s tarmed.sqlite3 ../db/tarmed_production.sqlite3
ln -s tarmed.sqlite3 ../db/tarmed_test.sqlite3

# Cleanup
rm TARMED_Database_V01.06.zip TARMED_Database_V01.06.mdb

# Import as TariffItems
echo "Tarmed::Base.import" | ../script/console
