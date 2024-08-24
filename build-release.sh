#! /bin/bash

if [ -z "$1" ]; then
    echo "No Debian snapshot provided" 1>&2
    exit 1
fi

set -ex

for a in i386 armhf amd64 arm64 riscv64; do
    xfce4-terminal -x ./build.sh $a $DEBIAN_SNAPSHOT &
done

while :; do
    if \
        test -f debian-rootfs-i386.tar.gz && \
        test -f debian-rootfs-armhf.tar.gz && \
        test -f debian-rootfs-amd64.tar.gz && \
        test -f debian-rootfs-arm64.tar.gz && \
        test -f debian-rootfs-riscv64.tar.gz; then break; fi
    sleep 1
done

git tag $DEBIAN_SNAPSHOT
git push --tags
gh release create $DEBIAN_SNAPSHOT \
    --notes "Debian rootfs from snapshot $DEBIAN_SNAPSHOT" \
    ./*.tar.gz
