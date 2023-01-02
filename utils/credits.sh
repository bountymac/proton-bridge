#!/bin/bash

# Copyright (c) 2023 Proton AG
#
# This file is part of Proton Mail Bridge.
#
# Proton Mail Bridge is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Proton Mail Bridge is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Proton Mail Bridge. If not, see <https://www.gnu.org/licenses/>.

## Generate credits from go.mod

PACKAGE=$1

# Vendor packages
LOCKFILE=../go.mod
TEMPFILE1=$(mktemp)
TEMPFILE2=$(mktemp)

egrep $'^\t[^=>]*$' $LOCKFILE  | sed -r 's/\t([^ ]*) v.*/\1/g' > $TEMPFILE1
egrep $'^\t.*=>.*v.*$' $LOCKFILE  | sed -r 's/^.*=> ([^ ]*)( v.*)?/\1/g' >> $TEMPFILE1
cat $TEMPFILE1 | egrep -v 'therecipe/qt/internal|therecipe/env_.*_512|protontech' | sort | uniq > $TEMPFILE2
# Add non vendor credits
echo -e "\nQt 6.3.1 by Qt group\n" >> $TEMPFILE2
# join lines
sed -i -e ':a' -e 'N' -e '$!ba' -e 's|\n|;|g' $TEMPFILE2

cat ../utils/license_header.txt > ../internal/$PACKAGE/credits.go
echo -e '// Code generated by '`echo $0`' at '`date`'. DO NOT EDIT.\n\npackage '$PACKAGE'\n\nconst Credits = "'$(cat $TEMPFILE2)'"' >> ../internal/$PACKAGE/credits.go
rm $TEMPFILE1 $TEMPFILE2
