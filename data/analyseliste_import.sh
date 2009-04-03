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

INPUT=$1
OUTPUT=$2

pdftotext -layout -enc Latin1 -f 143 $1 - | sed ':more;/[^[:digit:]]$/N;s/\n / /g;tmore' | sed 's/- //g' | sed -n 's/\(^.*[^[:blank:]]\)[[:blank:]]*\([[:digit:]]\{4\}.[[:digit:]]\{2\}.*\)/\1|\2/p' >$2
