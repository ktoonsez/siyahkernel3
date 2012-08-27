#!/bin/sh
export KERNELDIR=`readlink -f .`
export INITRAMFS_SOURCE=`readlink -f $KERNELDIR/../initramfsJB`
export PARENT_DIR=`readlink -f ..`
export USE_SEC_FIPS_MODE=true

if [ "${1}" != "" ];then
  export KERNELDIR=`readlink -f ${1}`
fi

export ARCH=arm
# export CROSS_COMPILE=$PARENT_DIR/linaro4.7-2012.04/bin/arm-eabi-
export CROSS_COMPILE=/home/ktoonsez/androidjb/system/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-

echo "Remove old zImage"
rm zImage

INITRAMFS_TMP="/tmp/initramfs-source"

if [ ! -f $KERNELDIR/.config ];
then
  make siyah_i777_defconfig
fi

. $KERNELDIR/.config

cd $KERNELDIR/
nice -n 10 make -j`grep 'processor' /proc/cpuinfo | wc -l` || exit 1

#remove previous initramfs files
rm -rf $INITRAMFS_TMP
rm -rf $INITRAMFS_TMP.cpio
#copy initramfs files to tmp directory
cp -ax $INITRAMFS_SOURCE $INITRAMFS_TMP
#clear git repositories in initramfs
find $INITRAMFS_TMP -name .git -exec rm -rf {} \;
#remove empty directory placeholders
find $INITRAMFS_TMP -name EMPTY_DIRECTORY -exec rm -rf {} \;
rm -rf $INITRAMFS_TMP/tmp/*
#remove mercurial repository
rm -rf $INITRAMFS_TMP/.hg
#copy modules into initramfs
mkdir -p $INITRAMFS/lib/modules
find -name '*.ko' -exec cp -av {} $INITRAMFS_TMP/lib/modules/ \;
chmod 644 $INITRAMFS_TMP/lib/modules/*
${CROSS_COMPILE}strip --strip-unneeded $INITRAMFS_TMP/lib/modules/*

nice -n 10 make -j`grep 'processor' /proc/cpuinfo | wc -l` zImage CONFIG_INITRAMFS_SOURCE="$INITRAMFS_TMP" || exit 1

#cp $KERNELDIR/arch/arm/boot/zImage zImage
$KERNELDIR/mkshbootimg.py $KERNELDIR/zImage $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/payload.tar $KERNELDIR/recovery.tar.xz

