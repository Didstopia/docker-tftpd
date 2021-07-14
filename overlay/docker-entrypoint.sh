#!/usr/bin/env bash
set -e

# set -x

PUID="${PUID:-100}"
PGID="${PGID:-101}"

CMD="$@"

# Start syslog
# touch /var/log/syslog
/usr/sbin/syslog-ng
# /usr/sbin/syslog-ng --cfgfile=/etc/syslog-ng/syslog-ng.conf --verbose

# Convert all files and folder to lowercase
set +e
for i in `find /data/ -type d && find /data/ -type f`; do
  mv $i `echo $i | tr [:upper:] [:lower:]` >/dev/null 2>&1
done
set -e

echo ""
echo "----------------------------------------"
echo " Starting tftpd, using the following:   "
echo "                                        "
echo "     UID: $PUID                         "
echo "     GID: $PGID                         "
echo "----------------------------------------"
echo ""

# Set UID/GID of tftpd user
sed -i "s/^tftpd\:x\:100\:101/tftpd\:x\:$PUID\:$PGID/" /etc/passwd
sed -i "s/^tftpd\:x\:101/tftpd\:x\:$PGID/" /etc/group

if [[ $@ == /usr/sbin/in.tftpd* ]]; then
  if [ "${TFTPD_DEBUG,,}" = "true" ]; then
    echo "Enabling debugging"
    echo
    # CMD="${CMD} -vvvv"
    CMD="${CMD} --verbosity 4"
    # CMD="${CMD} -vvvvvv"
  fi

  # Apply default arguments last
  CMD="${CMD} --port-range 4096:32767 -m /var/lib/tftpboot/pxelinux.cfg/remap --foreground --user tftpd --secure /data"
fi

# Set permissions
chown -R $PUID:$PGID /data

echo "Executing command: ${CMD}"
echo

tail -f /dev/stdout /dev/stderr /var/log/messages &

eval "${CMD}"
# exec $CMD
