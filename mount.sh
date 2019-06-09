#!/sbin/sh
#
##############################################################
# File name       : mount.sh
#
# Requirement     : Magisk
#
# Compatibility   : Add support to mount A-only Partition
#
# Description     : A-only Partition mount script for BiTGApps
#
# Build Date      : Friday March 15 11:36:43 IST 2019
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

mounts=""
for p in "/cache" "/data" "/persist" "/system" "/vendor"; do
  if [ -d "$p" ] && grep -q "$p" "/etc/fstab" && ! mountpoint -q "$p"; then
    mounts="$mounts $p"
  fi
done

for m in $mounts; do
  mount "$m"
done

# remount /system, /vendor sometimes necessary if mounted read-only
grep -q "/system.*\sro[\s,]" /proc/mounts && mount -o rw /system
grep -q "/vendor.*\sro[\s,]" /proc/mounts && mount -o rw /vendor
