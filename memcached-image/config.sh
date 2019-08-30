#!/bin/bash

set -e

# that's what gets extracted from the archive (see the .kiwi file)
# the archive itself is created by the OBS services (see _service)
ln -s /memcached-docker-entrypoint/docker-entrypoint.sh /usr/local/sbin/

exit 0
