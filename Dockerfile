FROM alpine:3.6
MAINTAINER Johan Swetzén <johan@swetzen.com>

EXPOSE 53 80 443

RUN apk add --no-cache python py-pillow openssl git

ENV PLEXCONNECT_ENABLE_PLEXGDM=True \
    PLEXCONNECT_ENABLE_PLEXCONNECT_AUTODETECT=True \
    PLEXCONNECT_ENABLE_PLEXCONNECT_AUTODETECT_OUTSIDE=False \
    PLEXCONNECT_IP_PLEXCONNECT=0.0.0.0 \
    PLEXCONNECT_IP_OUTSIDE=192.168.1.2 \
    PLEXCONNECT_IP_PMS=192.168.1.10 \
    PLEXCONNECT_PORT_PMS=32400 \
    PLEXCONNECT_IP_DNSMASTER=8.8.8.8 \
    PLEXCONNECT_PREVENT_ATV_UPDATE=True \
    PLEXCONNECT_HOSTTOINTERCEPT=trailers.apple.com \
    PLEXCONNECT_LOGLEVEL=Normal \
    GIT_REPO_SHA=""

RUN git clone https://github.com/jswetzen/PlexConnect.git /opt/plexconnect

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD python /opt/plexconnect/PlexConnect.py

VOLUME ["/mnt/plexconnect-config"]
