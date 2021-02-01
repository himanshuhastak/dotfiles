#!/bin/bash

RSYNC_SKIP_COMPRESS="3fr/3g2/3gp/3gpp/7z/aac/ace/amr/apk/appx/appxbundle/arc/arj/arw/asf/avi/bz/bz2/cab/cr2/crypt[5678]/dat/dcr/deb/dmg/drc/ear/erf/flac/flv/gif/gpg/gz/iiq/jar/jp2/jpeg/jpg/h26[45]/k25/kdc/kgb/lha/lz/lzma/lzo/lzx/m4[apv]/mef/mkv/mos/mov/mp[34]/mpeg/mp[gv]/msi/nef/oga/ogg/ogv/opus/orf/pak/pef/png/qt/rar/r[0-9][0-9]/rz/rpm/rw2/rzip/sfark/sfx/s7z/sr2/srf/svgz/t[gb]z/tlz/txz/vob/wim/wma/wmv/xz/zip/tar"
RSYNC_ARGS="-ralHAXxvutz --human-readable --no-motd --numeric-ids -P  --log-file=.rsynclog "
SSH_CIPHER="aes128-gcm@openssh.com"

time  eval rsync $RSYNC_ARGS --skip-compress=$RSYNC_SKIP_COMPRESS  -e \"ssh -T -c $SSH_CIPHER -o Compression=no -x \" $*

EXIT_STATUS=$?
if [[ "$EXIT_STATUS" == "255" ]] ; then
    SSH_CIPHER=arcfour
fi

time  eval rsync $RSYNC_ARGS --skip-compress=$RSYNC_SKIP_COMPRESS  -e \"ssh -T -c $SSH_CIPHER -o Compression=no -x \" $*
