#! /bin/bash

set -ex

DEBIAN_SNAPSHOT=20240823T164440Z

for a in i386 armhf amd64 arm64 riscv64; do
    ./build.sh $a $DEBIAN_SNAPSHOT &
done

wait

git tag $DEBIAN_SNAPSHOT
git push --tags
gh release create $DEBIAN_SNAPSHOT \
    --notes "Debian rootfs from snapshot $DEBIAN_SNAPSHOT" \
    ./*.tar.gz
