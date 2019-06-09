#!/sbin/sh
#
##############################################################
# File name       : umount.sh
#
# Requirement     : Magisk
#
# Description     : Partitions unmount script for BiTGApps
#
# Build Date      : Sunday April 28 17:38:57 IST 2019
#
# GitHub          : TheHitMan7 <krtik.vrma@gmail.com>
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2019 TheHitMan7
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
##############################################################

BB=/tmp/install/tools/busybox;

# Detect A/B partition layout https://source.android.com/devices/tech/ota/ab_updates
# and system-as-root https://source.android.com/devices/bootloader/system-as-root
if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ];
then
  device_abpartition=true
  SYSTEM=/system/system
  VENDOR=/vendor/vendor
elif [ -n "$(cat /proc/mounts | grep /system_root)" ];
then
  device_abpartition=true
  SYSTEM=/system_root/system
  VENDOR=/vendor
else
  device_abpartition=false
  SYSTEM=/system
  VENDOR=/vendor
fi

if [ "$device_abpartition" = "true" ]; then
    mount -o ro /system
    mount -o ro /vendor
else
    umount /system
    umount /vendor
fi;
