#!/sbin/sh
#
##############################################################
# File name       : enforce.sh
#
# Description     : Remove priv app enforcing variables
#
# Build Date      : Monday August 12 20:31:20 IST 2019
#
# Updated on      : Friday August 16 09:41:26 IST 2019
#
# GitHub          : TheHitMan7 <krtik.vrma@gmail.com>
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2019 TheHitMan7
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
#
# The BiTGApps scripts are free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version, w/BiTGApps installable zip exception.
#
# These scripts are distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
##############################################################

LOG="/cache/bitgapps/enforce.log";

ui_print() {
  until [ ! "$1" ]; do
    echo -e "ui_print $1\nui_print" > $OUTFD;
    shift;
  done;
}

set_progress() { echo "set_progress $1" > "$OUTFD"; }

# Detect A/B partition layout https://source.android.com/devices/tech/ota/ab_updates
# and system-as-root https://source.android.com/devices/bootloader/system-as-root
if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ];
then
  device_abpartition=true
  SYSTEM_MOUNT=/system
  SYSTEM=$SYSTEM_MOUNT/system
  SYSTEM_VENDOR=/system/vendor
elif [ -n "$(cat /etc/fstab | grep /system_root)" ];
then
  device_abpartition=false
  SYSTEM_MOUNT=/system_root
  SYSTEM=$SYSTEM_MOUNT/system
  SYSTEM_VENDOR=/system/vendor
else
  device_abpartition=false
  SYSTEM_MOUNT=/system
  SYSTEM=$SYSTEM_MOUNT
  SYSTEM_VENDOR=/system/vendor
fi

PROPFILES="$SYSTEM/build.prop $SYSTEM_VENDOR/build.prop"

get_file_prop() {
  grep -m1 "^$2=" "$1" | cut -d= -f2
}

get_prop() {
  #check known .prop files using get_file_prop
  for f in $PROPFILES; do
    if [ -e "$f" ]; then
      prop="$(get_file_prop "$f" "$1")"
      if [ -n "$prop" ]; then
        break #if an entry has been found, break out of the loop
      fi
    fi
  done
  #if prop is still empty; try to use recovery's built-in getprop method; otherwise output current result
  if [ -z "$prop" ]; then
    getprop "$1" | cut -c1-
  else
    printf "$prop"
  fi
}

# insert_line <file> <if search string> <before|after> <line match string> <inserted line>
insert_line() {
  local offset line;
  if ! grep -q "$2" $1; then
    case $3 in
      before) offset=0;;
      after) offset=1;;
    esac;
    line=$((`grep -n "$4" $1 | head -n1 | cut -d: -f1` + offset));
    if [ -f $1 -a "$line" ] && [ "$(wc -l $1 | cut -d\  -f1)" -lt "$line" ]; then
      echo "$5" >> $1;
    else
      sed -i "${line}s;^;${5}\n;" $1;
    fi;
  fi;
}

# replace_line <file> <line replace string> <replacement line>
replace_line() {
  if grep -q "$2" $1; then
    local line=$(grep -n "$2" $1 | head -n1 | cut -d: -f1);
    sed -i "${line}s;.*;${3};" $1;
  fi;
}

# remove_line <file> <line match string>
remove_line() {
  if grep -q "$2" $1; then
    local line=$(grep -n "$2" $1 | head -n1 | cut -d: -f1);
    sed -i "${line}d" $1;
  fi;
}

android_flag="$(get_prop "ro.control_privapp_permissions")";
supported_flag_enforce="enforce";
supported_flag_disable="disable";
supported_flag_log="log";
PROPFLAG="ro.control_privapp_permissions";

echo "-----------------------------------" >> $LOG
echo "Disable Installed flags" >> $LOG;
echo "FLAG: $android_flag" >> $LOG;
echo "-----------------------------------" >> $LOG
echo "DIR:: /system" >> $LOG;
if [ -f "$SYSTEM/build.prop" ]; then
    grep -v "$PROPFLAG" $SYSTEM/build.prop > /tmp/build.prop
    rm -rf $SYSTEM/build.prop
    cp -f /tmp/build.prop $SYSTEM/build.prop
    chmod 0644 $SYSTEM/build.prop
    rm -rf /tmp/build.prop
fi;
echo "DIR:: /vendor" >> $LOG;
if [ -f "$SYSTEM_VENDOR/build.prop" ]; then
    grep -v "$PROPFLAG" $SYSTEM_VENDOR/build.prop > /tmp/build.prop
    rm -rf $SYSTEM_VENDOR/build.prop
    cp -f /tmp/build.prop $SYSTEM_VENDOR/build.prop
    chmod 0644 $SYSTEM_VENDOR/build.prop
    rm -rf /tmp/build.prop
fi;

# Re-add Privileged Permission Whitelist property with flag 'disable',
# completely removing 'enforce' permission may cause some devices not to boot into system.
#
# Below command should not be conditional for enforcing flag else it may fail.
if [ -f "$SYSTEM/build.prop" ]; then
    insert_line $SYSTEM/build.prop "ro.control_privapp_permissions=disable" after 'ro.bionic.ld.warning=1' 'ro.control_privapp_permissions=disable';
fi;
if [ -f "$SYSTEM_VENDOR/build.prop" ]; then
    insert_line $SYSTEM_VENDOR/build.prop "ro.control_privapp_permissions=disable" after 'DEVICE_PROVISIONED=1' 'ro.control_privapp_permissions=disable';
fi;

# end method
