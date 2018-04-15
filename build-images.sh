#!/bin/bash

cat <<'EOF'
This script creates 3 docker images.  One for the custom glibc, the
other two for x86_64 and i686 builds, respectively.  The first one can
be removed; but it'll speed up a build at a later time significantly.

All docker images are prefixed with the user's name ($USERNAME).

Note: out of necessity, the script modifies 'docker/Dockerfile-x86_64',
replacing the prefix.
EOF

pushd $(dirname "$0") > /dev/null 2>&1
set -e -x

DOCKER_PREFIX=${USERNAME:-myself}
docker/build_scripts/prefetch.sh curl openssl
pushd docker/glibc/
docker build -t "${DOCKER_PREFIX}/manylinux2010_centos-6.9-no-vsyscall" .
popd
sed -i -e "s/FROM .*\(\/manylinux2010_centos-6.9-no-vsyscall\)/FROM ${DOCKER_PREFIX}\1/" docker/Dockerfile-x86_64
docker build -t "${DOCKER_PREFIX}/manylinux2010_x86_64" -f docker/Dockerfile-x86_64 docker/
docker build -t "${DOCKER_PREFIX}/manylinux2010_i686" -f docker/Dockerfile-i686 docker/
 
popd > /dev/null 2>&1
