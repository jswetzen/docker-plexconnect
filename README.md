# Basic Usage

Running PlexConnect with PMS on `1.2.3.4` and the Docker host on `192.168.0.2`.
The PlexConnect configuration will be mounted as a volume so that certificates
and Plex login details are persistent.

    docker run -d --name plexconnect \
      -p53:53/udp -p80:80 -p443:443 \
      -e PLEXCONNECT_ENABLE_PLEXGDM=False \
      -e PLEXCONNECT_IP_PMS=1.2.3.4 \
      -e PLEXCONNECT_ENABLE_PLEXCONNECT_AUTODETECT_OUTSIDE=False \
      -e PLEXCONNECT_IP_OUTSIDE=192.168.0.2 \
      jswetzen/plexconnect

Stop the container with `docker kill plexconnect`. The Apple TV needs to be
configured as described in the
[wiki](https://github.com/iBaa/PlexConnect/wiki/Install-Guide#setup-your-atv).

## Accessing the settings volume
The 

The PlexConnect configuration will be mounted as a volume at
`/opt/plexconnect-config` on the host machine so that certificates and Plex
login details are persistent.

# Supported tags and architectures

For use on a normal machine, use the `latest` tag.
For ARM computers (like the Raspberry Pi) use `arm32v7`.

# Environment variables

All settings available in the
[Settings.cfg file](https://github.com/iBaa/PlexConnect/wiki/Settings-for-advanced-use-and-troubleshooting)
can be set by passing environment variables to the container, prefixed with
`PLEXCONNECT_`. Some of the most important settings are described below.


- `PLEXCONNECT_ENABLE_PLEXGDM` (True): Set to `False` to set `ip_pms` manually.
- `PLEXCONNECT_IP_PMS` (192.168.1.10): IP for Plex Media Server (PMS).
- `PLEXCONNECT_ENABLE_PLEXCONNECT_AUTODETECT` (True): Set to `False` to set
  `ip_plexconnect` manually. Only use it if you know what you're doing.
- `PLEXCONNECT_IP_PLEXCONNECT` (0.0.0.0): Internal IP for PlexConnect.
- `PLEXCONNECT_ENABLE_PLEXCONNECT_AUTODETECT_OUTSIDE` (False): Set to `True` to
  try to detect Docker host IP automatically. This is not recommended.
- `PLEXCONNECT_IP_OUTSIDE` (192.168.1.2): IP of the Docker host.
- `PLEXCONNECT_PORT_PMS` (32400): Plex Media Server port.
- `PLEXCONNECT_IP_DNSMASTER` (8.8.8.8): DNS server for everything but Plex.
- `PLEXCONNECT_PREVENT_ATV_UPDATE` (True): Stop Apple TV from updating.
- `PLEXCONNECT_HOSTTOINTERCEPT` (trailers.apple.com): Change this to use something
  other than the Trailers app for Plex.
- `GIT_REPO_SHA` (""): You can optionally set a specific PlexConnect commit.
  Useful for testing or "pinning down" a commit that is known to work.

Note that Settings.cfg is generated based on the environment
only in case it does not exist already, so usually only on the first start.
If the plexconnect directory is mounted as a volume, as recommended, this means
that it is only generated again if manually removed from the host. At that
point it is of course possible to edit the file directly.

# Support

Add a [GitHub issue](https://github.com/jswetzen/docker-plexconnect/issues).
