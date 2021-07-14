#!/usr/bin/with-contenv /bin/bash

set -e

# set -x

# Convert all files and folder to lowercase
set +e
for i in `find /data/ -type d && find /data/ -type f`; do
  mv $i `echo $i | tr [:upper:] [:lower:]` >/dev/null 2>&1
done
set -e

# Set UID/GID of tftpd user
sed -i "s/^tftpd\:x\:100\:101/tftpd\:x\:$PUID\:$PGID/" /etc/passwd
sed -i "s/^tftpd\:x\:101/tftpd\:x\:$PGID/" /etc/group

if [ "${TFTPD_DEBUG,,}" = "true" ]; then
  sed -i 's/\/data$/\/data --verbosity 4/' /etc/services.d/in.tftpd/run
  # cat /etc/services.d/in.tftpd/run
else
  sed -i 's/\ --verbosity 4$//' /etc/services.d/in.tftpd/run
  # cat /etc/services.d/in.tftpd/run
fi

# Set permissions
chown -R $PUID:$PGID /data
