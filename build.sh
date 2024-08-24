#! /bin/bash

set -ex

sudo mkdir debian-rootfs-$1

case "$1" in
    amd64)
        sudo debootstrap --arch=$1 sid debian-rootfs-$1 https://snapshot.debian.org/archive/debian/$2/
        ;;
    *)
        sudo debootstrap --arch=$1 --foreign sid debian-rootfs-$1 https://snapshot.debian.org/archive/debian/$2/
        ;;
esac

sudo rm -f debian-rootfs-$1/dev/{console,full,null,ptmx,random,tty,urandom,zero}

case "$1" in
    amd64)
        ;;
    *)
        sudo arch-chroot debian-rootfs-$1 /debootstrap/debootstrap --second-stage
        ;;
esac

sudo bsdtar -zcf debian-rootfs-$1.tar.gz debian-rootfs-$1

sudo chown $(id -u):$(id -g) debian-rootfs-$1.tar.gz
