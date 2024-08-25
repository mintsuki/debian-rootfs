#! /bin/bash

if [ -z "$1" ]; then
    echo "No Debian snapshot provided" 1>&2
    exit 1
fi

set -ex

for a in amd64 arm64 armel armhf i386 mips64el ppc64el riscv64 s390x; do
    xfce4-terminal -x ./build.sh $a $1 &
done

while :; do
    if \
        test -f debian-rootfs-amd64.done && \
        test -f debian-rootfs-arm64.done && \
        test -f debian-rootfs-armel.done && \
        test -f debian-rootfs-armhf.done && \
        test -f debian-rootfs-arm64.done && \
        test -f debian-rootfs-i386.done && \
        test -f debian-rootfs-mips64el.done && \
        test -f debian-rootfs-ppc64el.done && \
        test -f debian-rootfs-riscv64.done && \
        test -f debian-rootfs-s390x.done; then break; fi
    sleep 1
done

git tag $1
git push --tags
gh release create $1 \
    --notes "Debian rootfs from snapshot $1" \
    ./*.tar.xz
