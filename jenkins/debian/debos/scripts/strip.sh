#!/bin/sh

# Strip the image to a small minimal system without removing the debian
# toolchain.

set -e

# Copy timezone file and remove tzdata package
rm -rf /etc/localtime
cp /usr/share/zoneinfo/Etc/UTC /etc/localtime


UNNEEDED_PACKAGES=" libfdisk1"\
" tzdata"\

export DEBIAN_FRONTEND=noninteractive

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

# Dropping documentation, localization, i18n files, etc
rm -rf /usr/share/doc/*
rm -rf /usr/share/locale/*
rm -rf /usr/share/man
rm -rf /usr/share/i18n/*
rm -rf /usr/share/info/*
rm -rf /usr/share/lintian/*
rm -rf /usr/share/common-licenses/*
rm -rf /usr/share/mime/*

# Dropping reportbug scripts
rm -rf /usr/share/bug

# we won't build any sudo plugin
rm /usr/include/sudo_plugin.h

# Drop udev hwdb not required on a stripped system
rm -f /lib/udev/hwdb.bin /lib/udev/hwdb.d/*

# Drop all gconv conversions && binaries
rm usr/bin/iconv
rm usr/sbin/iconvconfig
rm -rf usr/lib/*/gconv/

# Remove libusb database
rm usr/sbin/update-usbids
rm var/lib/usbutils/usb.ids
rm usr/share/misc/usb.ids
