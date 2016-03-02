#!/bin/bash

if [ -n "$HOSTNAME" ]; then
 hostname $HOSTNAME
else
 hostname pitrap
fi

# configure papertrail host
sed -i "s/LOG_ENDPOINT/$LOG_ENDPOINT/" /etc/rsyslog.d/80-papertrail.conf

# starting services
service rsyslog start
service arpwatch start

# cleanup scanlogs on startup
if [ -f /var/log/scanlog ]; then
  rm -f /var/log/scanlog
fi

logger "Starting pitrap main thread"
exec "$@"
