#!/bin/sh
#
# Install anvo-core from local .deb packages.
# Place the packages in docker/packages/ before building:
#   anvo-core_*_amd64.deb  (x86_64)
#   anvo-core_*_arm64.deb  (aarch64)

ARCH=$(uname -m)

if [ "${ARCH}" = "x86_64" ]; then
   apt-get install -y /app/packages/anvo-core_*_amd64.deb
elif [ "${ARCH}" = "aarch64" ]; then
   apt-get install -y /app/packages/anvo-core_*_arm64.deb
else
   echo "Unsupported architecture: ${ARCH}"
   exit 1
fi
