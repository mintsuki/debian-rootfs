#! /bin/bash

if [ -z "$1" ]; then
    echo "Specify an architecture" 1>&2
    exit 1
fi

if [ -z "$2" ]; then
    echo "Specify a snapshot" 1>&2
    exit 1
fi

set -ex

sudo rm -rf debian-rootfs-$1
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

sudo rm debian-rootfs-$1/etc/resolv.conf
sudo touch debian-rootfs-$1/etc/resolv.conf

sudo rm debian-rootfs-$1/etc/hostname
sudo sh -c "echo localhost >debian-rootfs-$1/etc/hostname"

sudo tar -Jcf debian-rootfs-$1.tar.xz debian-rootfs-$1

sudo chown $(id -u):$(id -g) debian-rootfs-$1.tar.xz

touch debian-rootfs-$1.done
