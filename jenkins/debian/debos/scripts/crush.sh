#!/bin/sh
set -ve

# Crush into a minimal production image to be deployed via some type of image
# updating system. The Debian system is not longer functional at this point.

UNNEEDED_PACKAGES="openssl "\
"apt apt-transport-https libapt-pkg5.0 "\
"ncurses-bin ncurses-base "\
"perl-base "\
"adduser "\
"debconf "\
"sysv-rc "\
"dracut dracut-core "\
"ostree-boot "\
"e2fsprogs e2fslibs libfdisk1 libdevmapper1.02.1 "\
"insserv "\
"init-system-helpers "\
"bash "\
"cpio "\
"apertis-archive-keyring "\
"libdebconfclient0 "\
"passwd "\
"libsemanage1 "\
"libsemanage-common "\
"libsepol1 "\
"gzip "\
"gnupg "\
"gpgv "\
"libcurl3 "\
"hostname "\
"openssh-client "

# gnupg has a helper too that uses ldap, which drags in libldap which drags in
# the whole kerberos stack and sasl and and.
UNNEEDED_PACKAGES="${UNNEEDED_PACKAGES} "\
"libldap-2.4-2 "\
"libasn1-8-heimdal"\
"libheimntlm0-heimdal "\
"libheimbase1-heimdal "\
"libroken18-heimdal "\
"libhx509-5-heimdal "\
"libhcrypto4-heimdal "\
"libgssapi3-heimdal "\
"libkrb5-26-heimdal "\
"libsasl2-2 "\
"libsasl2-modules-db "

# The following can also be removed if openssh isn't used
#"libgssapi-krb5-2 "\
#"libkrb5-3 "\
#"libkrb5support0 "\
#"libk5crypto3 "\
#"libkeyutils1 "\

# Needed by an ostree helper only
UNNEEDED_PACKAGES="${UNNEEDED_PACKAGES} "\
"libfuse2 "

# Drop ncurses only required for some command line utils
UNNEEDED_PACKAGES="${UNNEEDED_PACKAGES} "\
"libncursesw5 "\
"libncurses5 "

# Removing unused packages
for PACKAGE in ${UNNEEDED_PACKAGES}
do
	echo "Forcing removal of ${PACKAGE}"
	if ! dpkg --purge --force-remove-essential --force-depends "${PACKAGE}"
	then
		echo "WARNING: ${PACKAGE} isn't installed"
	fi
done

# Show what's left package-wise before dropping dpkg itself
COLUMNS=300 dpkg -l

# Drop dpkg
dpkg --purge --force-remove-essential --force-depends  dpkg

# Drop directories not part of ostree
# Note that /var needs to exist as ostree bind mounts the deployment /var over
# it
rm -rf var/* opt srv share

# ca-certificates are in /etc drop the source 
rm -rf usr/share/ca-certificates

# No bash, no need for completions
rm -rf usr/share/bash-completion

# No zsh, no need for comletions
rm -rf usr/share/zsh/vendor-completions

# drop gcc-5 python helpers
rm -rf usr/share/gcc-5

# Drop sysvinit leftovers
rm -rf etc/init.d
rm -rf etc/rc[0-6S].d

# Drop upstart helpers
rm -rf etc/init

# Various xtables helpers
rm -rf usr/lib/xtables

# Drop all locales
rm -rf usr/lib/locale/*

# configuration helpers
rm -f usr/sbin/visudo usr/sbin/useradd usr/sbin/usermod usr/sbin/chpasswd

# partition helpers
rm usr/sbin/*fdisk

# local compiler 
rm usr/bin/localedef

# Systemd dns resolver
#find usr etc -name '*systemd-resolve*' -prune -exec rm -r {} \;

# Systemd network configuration
#find usr etc -name '*networkd*' -prune -exec rm -r {} \;

# systemd ntp client (connman is in use)
#find usr etc -name '*timesyncd*' -prune -exec rm -r {} \;

# systemd hw database manager (connman is in use)
find usr etc -name '*systemd-hwdb*' -prune -exec rm -r {} \;

# No need for fuse
find usr etc -name '*fuse*' -prune -exec rm -r {} \;

# lsb init function leftovers
rm -rf usr/lib/lsb

# Utils using ncurses
rm usr/bin/pg
rm usr/bin/watch
rm usr/bin/slabtop

# boot analyser
rm usr/bin/systemd-analyze

# Only needed when adding libraries
rm usr/sbin/ldconfig*

# Games, unused
rmdir usr/games

# Unused systemd generators
rm lib/systemd/system-generators/systemd-cryptsetup-generator
rm lib/systemd/system-generators/systemd-debug-generator
rm lib/systemd/system-generators/systemd-gpt-auto-generator
rm lib/systemd/system-generators/systemd-hibernate-resume-generator
rm lib/systemd/system-generators/systemd-rc-local-generator
rm lib/systemd/system-generators/systemd-system-update-generator
rm lib/systemd/system-generators/systemd-sysv-generator


# Efi blobs
rm -rf usr/lib/systemd/boot

# Translation catalogs
rm -rf usr/lib/systemd/catalog

# Misc systemd utils
rm usr/bin/bootctl
rm usr/bin/busctl
rm usr/bin/hostnamectl
rm usr/bin/localectl
rm usr/bin/systemd-cat
rm usr/bin/systemd-cgls
rm usr/bin/systemd-cgtop
rm usr/bin/systemd-delta
rm usr/bin/systemd-detect-virt
rm usr/bin/systemd-mount
rm usr/bin/systemd-path
rm usr/bin/systemd-run
rm usr/bin/systemd-socket-activate
