#!/bin/sh

# Link configs and certificates
if [ ! -f "/mnt/plexconnect-config/ATVSettings.cfg" ]; then
  touch "/mnt/plexconnect-config/ATVSettings.cfg"
fi
# Create Settings.cfg from ENV vars
if [ ! -f "/mnt/plexconnect-config/Settings.cfg" ]; then
  echo "[PlexConnect]" > /mnt/plexconnect-config/Settings.cfg
  env | grep '^PLEXCONNECT_' | sed -E -e 's/^PLEXCONNECT_//' -e 's/(.*)=/\1 /' | awk '{printf "%s", tolower($1); $1=""; print " =" $0}' >> /mnt/plexconnect-config/Settings.cfg
fi
ln -s "/mnt/plexconnect-config/ATVSettings.cfg" "/opt/plexconnect/ATVSettings.cfg"
ln -s "/mnt/plexconnect-config/Settings.cfg" "/opt/plexconnect/Settings.cfg"
mkdir -p "/mnt/plexconnect-config/certificates"
rm -rf /opt/plexconnect/assets/certificates
ln -s "/mnt/plexconnect-config/certificates" "/opt/plexconnect/assets"

# Create ssl certificate if needed
if [ ! -f "/opt/plexconnect/assets/certificates/trailers.pem" ]; then
  cd "/opt/plexconnect/assets/certificates" || exit 1
  openssl req -new -nodes -newkey rsa:2048 -out trailers.pem -keyout trailers.key -x509 -days 365 -subj "/C=US/CN=trailers.apple.com"
  openssl x509 -in trailers.pem -outform der -out trailers.cer && cat trailers.key >> trailers.pem
  cd "/" || exit 1
fi

exec "$@"
