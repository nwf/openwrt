#!/bin/sh

set -e -x

if [ $# -ne 5 ]; then
    echo "SYNTAX: $0 <file> <bootfs image> <rootfs image> <bootfs size> <rootfs size>"
    exit 1
fi

OUTPUT="$1"
BOOTFS="$2"
ROOTFS="$3"
BOOTFSSIZE="$4"
ROOTFSSIZE="$5"

align=4096
head=4
kernel_type=c
rootfs_type=83
sect=63

set $(ptgen -o $OUTPUT -h $head -s $sect -l $align -t $kernel_type -p ${BOOTFSSIZE}M -t $rootfs_type -p ${ROOTFSSIZE}M ${SIGNATURE:+-S 0x$SIGNATURE})

BOOTOFFSET="$1"
ROOTFSOFFSET="$3"

dd bs=65536 if="$BOOTFS" of="$OUTPUT" seek="$BOOTOFFSET" conv=notrunc oflag=seek_bytes
dd bs=65536 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFSOFFSET" conv=notrunc oflag=seek_bytes
