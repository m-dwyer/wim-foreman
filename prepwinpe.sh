#!/usr/bin/env bash
set -x

ISOMOUNT=/tmp/winiso
STAGINGDIR=staging/
OVERLAYDIR=overlay/

ISOFILE=$1
FOREMANHOST=$2

echo "Creating mount point $ISOMOUNT.."
mkdir $ISOMOUNT

echo "Mounting ISO $ISOFILE.."
mount -o loop $ISOFILE $ISOMOUNT

echo "Clearing staging.."
[ -d $STAGINGDIR ] && rm -rf $STAGINGDIR/*
mkdir $STAGINGDIR/boot
mkdir $STAGINGDIR/sources

echo "Prepping WinPE.."
rm -f boot.wim
sed -e "s/\${FOREMANHOST}/$2/" peinit.cmd.sample > peinit.cmd
mkwinpeimg -W $ISOMOUNT -o -s peinit.cmd -O $OVERLAYDIR $STAGINGDIR/sources/boot.wim

echo "Copying install.wim.."
cp $ISOMOUNT/sources/install.wim $STAGINGDIR/sources
cp $ISOMOUNT/boot/bcd $STAGINGDIR/boot
cp $ISOMOUNT/boot/boot.sdi $STAGINGDIR/boot
cp $ISOMOUNT/bootmgr $STAGINGDIR/

echo "Copying wimboot.."
cp wimboot $STAGINGDIR 

echo "Unmounting ISO from $ISOMOUNT.."
umount $ISOMOUNT 

echo "Removing mount point.."
rm -rf $ISOMOUNT 

