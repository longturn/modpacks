#!/bin/sh

# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText:  Tobias Rehbein <tobias.rehbein@web.de>

# Checks that the version numbers in the index file match those in the
# modpacks.

IFS='|'
jq -r '.modpacks[] | "\(.name)|\(.version)|\(.url)"' index.json \
	| while read NAME VERSION URL; do
		RVERSION=$({ if $(echo "$URL" | grep -q '^http'); then
			curl -s "$URL"
		else
			cat "$URL"
		fi } | jq -r '.info.version')

		[ "$VERSION" != "$RVERSION" ] \
			&& echo "Version mismatch for \"$NAME\": index $VERSION; remote $RVERSION"
	done

