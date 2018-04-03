#!/bin/sh

# Strip the image to a small minimal system without removing the debian
# toolchain.

set -e

UNNEEDED_PACKAGES="libtext-wrapi18n-perl"\
" libtext-charwidth-perl"\
" libtext-iconv-perl liblocale-gettext-perl"\
" gcc-4.7-base gcc-4.8-base gcc-4.9-base"\
" uidmap xz-utils lzma"\
" libcurl3"\
" libfdisk1"\
" librtmp1"

# Removing unused packages
for PACKAGE in ${UNNEEDED_PACKAGES}
do
	echo ${PACKAGE}
	if ! apt-get remove --purge --yes "${PACKAGE}"
	then
		echo "WARNING: ${PACKAGE} isn't installed"
	fi
done

apt-get autoremove --yes || true

# Removing unused files
find . -name *~ -print0 | xargs -0 rm -f


# Dropping logs
rm -rf /var/log/*

# documentation & timezone information
rm -rf /usr/share/doc/*
rm -rf /usr/share/locale/*
rm -rf /usr/share/man
rm -rf /usr/share/i18n/*
rm -rf /usr/share/info/*
rm -rf /usr/share/lintian/*
rm -rf /usr/share/linda/*
rm -rf /usr/share/zoneinfo/*
rm -rf /usr/share/common-licenses/*
rm -rf /usr/share/mime/*

rm -rf /var/cache/man/*

# Drop udev hwdb not required on a stripped system
rm -f /lib/udev/hwdb.bin /lib/udev/hwdb.d/*

# Drop all gconf conversions apart from the more comon ISO ones and UTF8
rm usr/lib/*/gconv/lib*
rm usr/lib/*/gconv/[A-HJ-TV-Z]*
rm usr/lib/*/gconv/INIS*
rm usr/lib/*/gconv/IBM*
rm usr/lib/*/gconv/UHC*
