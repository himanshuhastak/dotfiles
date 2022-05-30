#! /usr/bin/env bash
# ------------------------------------------------
# Author:       hastakh
# Created:      Mon Feb  1 15:16:40 IST 2021
#
# Modifier:     hastakh
# Modified:     Mon May 30 14:34:00 IST 2022
#
# Usage:
#       rsync.sh user@host:/source/path/to/file user@host:/destination/path/to/file
#       can also pass extra arguments : like --exclude="*.log"
#
# Description:
#       faster way to rsync files
#       rsync.sh <src> <des>
#
# Tool Versions:
#       rsync  version 3.1.2 or later
# ------------------------------------------------
# set -x
# 2>&1

## shellcheck disable=SC2086 ## Double quote to prevent globbing and word splitting.

RSYNC_SKIP_COMPRESS="3fr/3g2/3gp/3gpp/7z/aac/ace/amr/apk/appx/appxbundle/arc/arj/arw/asf/avi/bz/bz2/cab/cr2/crypt[5678]/dat/dcr/deb/dmg/drc/ear/erf/flac/flv/gif/gpg/gz/iiq/jar/jp2/jpeg/jpg/h26[45]/k25/kdc/kgb/lha/lz/lzma/lzo/lzx/m4[apv]/mef/mkv/mos/mov/mp[34]/mpeg/mp[gv]/msi/nef/oga/ogg/ogv/opus/orf/pak/pef/png/qt/rar/r[0-9][0-9]/rz/rpm/rw2/rzip/sfark/sfx/s7z/sr2/srf/svgz/t[gb]z/tlz/txz/vob/wim/wma/wmv/xz/zip/tar"
RSYNC_ARGS="-ralHAXxvutz --human-readable --no-motd --numeric-ids -P --log-file=.rsynclog " # even if we pass z; we are skipping compression on few files formats
RSYNC_ARGS+=" --protocol 30 "                                                               #force older protocol, for version mismatches

# Speed of ciphers: (from faster ones to slower ones):: arcfour >> blowfish >> aes >> 3des
SSH_CIPHER=arcfour ## Seems there are security concerns with arcfour, use only at trusted locations
SSH_CIPHER=aes128-ctr

time eval rsync "$RSYNC_ARGS" --skip-compress="$RSYNC_SKIP_COMPRESS" -e \"ssh -T -c $SSH_CIPHER -o Compression=no -x -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \" "$*"
