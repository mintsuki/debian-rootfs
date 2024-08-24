#! /bin/bash

if [ -z "$1" ]; then
    echo "No Debian snapshot provided" 1>&2
    exit 1
fi

set -ex

for a in amd64 arm64 i386 riscv64; do
    xfce4-terminal -x ./build.sh $a $1 &
done

while :; do
    if \
        test -f debian-rootfs-amd64.done && \
        test -f debian-rootfs-arm64.done && \
        test -f debian-rootfs-i386.done && \
        test -f debian-rootfs-riscv64.done; then break; fi
    sleep 1
done

git tag $1
git push --tags
gh release create $1 \
    --notes "Debian rootfs from snapshot $1" \
    ./*.tar.xz
