#!/bin/bash

# Convert an MS Access database file to a PostgreSQL script file.
# This script uses the MDB Tools (http://mdbtools.sourceforge.net)
# Copyright (c) 2006, Daniel Lutz and Elexis
# Copyright (c) 2009, Simon Huerlimann <simon.huerlimann@cyt.ch> and ZytoLabor

TYPE=postgresql

function usage {
  echo "Usage: $0 [{--postgresql | --mysql | --help}] <MS Access File>"
  echo
  echo "This script converts an MS Access database file to PostgreSQL or MySQL commands,"
  echo "which then can be fed to the psql(1) or mysql(1) tools. The commands are written"
  echo "to standard output."
}

# make required changes for PostgreSQL
function convert_postgresql {
  cat
}

# make required changes for MySQL
function convert_mysql {
  cat | sed -e 's/DROP TABLE/DROP TABLE IF EXISTS/' | sed -e 's/^--/# --/'
}

# handle parameters

param=$1

if [ "$param" = "--postgresql" ]; then
  TYPE=postgresql
  shift
elif [ "$param" = "--mysql" ]; then
  TYPE=mysql
  shift
fi

param=$1

if [ "$param" = "--help" ]; then
  usage
  exit 0
fi

DB=$param

if [ -z "$DB" ]; then
  usage
  exit 1
fi

# extract schema

if [ "$TYPE" = "postgresql" ]; then
  mdb-schema $DB postgres | sed -e 's/Postgres_Unknown 0x0c/text/g' | sed -e 's/Char/varchar/g' | convert_postgresql
elif [ "$TYPE" = "mysql" ]; then
  mdb-schema $DB postgres | sed -e 's/Postgres_Unknown 0x0c/text/g' | sed -e 's/Char/varchar/g' | convert_mysql
fi

# extract data

for f in `mdb-tables $DB`; do mdb-export -q "'" -I -D '%Y-%m-%d %H:%M:%S' $DB $f; done | sed -e 's/)$/);/'

