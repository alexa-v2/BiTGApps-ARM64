#!/sbin/sh
#
##############################################################
# File name       : mount_ab.sh
#
# Requirement     : Magisk
#
# Compatibility   : Add support to mount A/B Partition
#
# Description     : A/B Partition mount script for BiTGApps
#
# Build Date      : Wednesday May 08 16:54:06 IST 2019
#
# GitHub          : TheHitMan7 <krtik.vrma@gmail.com>
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2019 TheHitMan7
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
##############################################################

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

ui_print() {
  $BOOTMODE && echo "$1" || echo -e "ui_print $1\nui_print" >> /proc/self/fd/$OUTFD
}

toupper() {
  echo "$@" | tr '[:lower:]' '[:upper:]'
}

grep_cmdline() {
  local REGEX="s/^$1=//p"
  cat /proc/cmdline | tr '[:space:]' '\n' | sed -n "$REGEX" 2>/dev/null
}

grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop'
  sed -n "$REGEX" $FILES 2>/dev/null | head -n 1
}

is_mounted() {
  grep -q " `readlink -f $1` " /proc/mounts 2>/dev/null
  return $?
}

find_block() {
  for BLOCK in "$@"; do
    DEVICE=`find /dev/block -type l -iname $BLOCK | head -n 1` 2>/dev/null
    if [ ! -z $DEVICE ]; then
      readlink -f $DEVICE
      return 0
    fi
  done
  # Fallback by parsing sysfs uevents
  for uevent in /sys/dev/block/*/uevent; do
    local DEVNAME=`grep_prop DEVNAME $uevent`
    local PARTNAME=`grep_prop PARTNAME $uevent`
    for BLOCK in "$@"; do
      if [ "`toupper $BLOCK`" = "`toupper $PARTNAME`" ]; then
        echo /dev/block/$DEVNAME
        return 0
      fi
    done
  done
  return 1
}

mount_part() {
  local PART=$1
  local POINT=/${PART}
  [ -L $POINT ] && rm -f $POINT
  mkdir $POINT 2>/dev/null
  is_mounted $POINT && return
  ui_print "- Mounting $PART"
  mount -o rw $POINT 2>/dev/null
  if ! is_mounted $POINT; then
    local BLOCK=`find_block $PART$SLOT`
    mount -o rw $BLOCK $POINT
  fi
  is_mounted $POINT || abort "! Cannot mount $POINT"
}

mount_partitions() {
  # Check A/B slot
  SLOT=`grep_cmdline androidboot.slot_suffix`
  if [ -z $SLOT ]; then
    SLOT=`grep_cmdline androidboot.slot`
    [ -z $SLOT ] || SLOT=_${SLOT}
  fi
  [ -z $SLOT ] || ui_print "- Current boot slot: $SLOT"

  mount_part system
  if [ -f /system/init.rc ]; then
    SYSTEM_ROOT=true
    [ -L /system_root ] && rm -f /system_root
    mkdir /system_root 2>/dev/null
    mount --move /system /system_root
    mount -o bind /system_root/system /system
  else
    grep -qE '/dev/root|/system_root' /proc/mounts && SYSTEM_ROOT=true || SYSTEM_ROOT=false
  fi
  [ -L /system/vendor ] && mount_part vendor
  $SYSTEM_ROOT && ui_print "- Device is system-as-root"
}

mount_partitions
