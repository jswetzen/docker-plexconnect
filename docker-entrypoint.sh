#!/bin/sh

# Clone repo if needed
if [ ! -f "/opt/plexconnect/PlexConnect.py" ] && [ "${GIT_REPO_SHA}" ]; then
  echo "Cloning git repo"
  git clone https://github.com/jswetzen/PlexConnect.git /opt/plexconnect
  cd "/opt/plexconnect" || exit 1
  git reset --hard "${GIT_REPO_SHA}"
  cd "/" || exit 1
fi

# Create ssl certificate if needed
if [ ! -f "/opt/plexconnect/assets/certificates/trailers.pem" ]; then
  cd "/opt/plexconnect/assets/certificates" || exit 1
  openssl req -new -nodes -newkey rsa:2048 -out trailers.pem -keyout trailers.key -x509 -days 365 -subj "/C=US/CN=trailers.apple.com"
  openssl x509 -in trailers.pem -outform der -out trailers.cer && cat trailers.key >> trailers.pem
  cd "/" || exit 1
fi

# Create Settings.cfg from ENV vars
if [ ! -f "/opt/plexconnect/Settings.cfg" ]; then
  echo "[PlexConnect]" > /opt/plexconnect/Settings.cfg
  env | grep '^PLEXCONNECT_' | sed -E -e 's/^PLEXCONNECT_//' -e 's/(.*)=/\1 /' | awk '{printf "%s", tolower($1); $1=""; print " =" $0}' >> /opt/plexconnect/Settings.cfg
fi

exec "$@"
