#!/bin/bash

INPUT=$1
OUTPUT=$2

pdftotext -layout -enc Latin1 -f 143 $1 - | sed ':more;/[^[:digit:]]$/N;s/\n / /g;tmore' | sed 's/- //g' | sed -n 's/\(^.*[^[:blank:]]\)[[:blank:]]*\([[:digit:]]\{4\}.[[:digit:]]\{2\}.*\)/\1|\2/p' >$2
