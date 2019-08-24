#!/sbin/sh
#
##############################################################
# File name       : installer.sh
#
# Description     : Setup installation, environmental variables and helper functions
#
# Build Date      : Friday March 15 11:36:43 IST 2019
#
# Updated on      : Monday July 29 20:40:12 IST 2019
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

# Detect A/B partition layout https://source.android.com/devices/tech/ota/ab_updates
# and system-as-root https://source.android.com/devices/bootloader/system-as-root
if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ];
then
  device_abpartition=true
  SYSTEM_MOUNT=/system
  SYSTEM=$SYSTEM_MOUNT/system
  VENDOR=/vendor
elif [ -n "$(cat /etc/fstab | grep /system_root)" ];
then
  device_abpartition=false
  SYSTEM_MOUNT=/system_root
  SYSTEM=$SYSTEM_MOUNT/system
  VENDOR=/vendor
else
  device_abpartition=false
  SYSTEM_MOUNT=/system
  SYSTEM=$SYSTEM_MOUNT
  VENDOR=/vendor
fi

# Set package defaults
TEMP="/cache"
LOGD="/cache/bitgapps"
LOG="/cache/bitgapps/installation.log"
TMP="/tmp"
ZIP_FILE="/tmp/zip"
UNZIP_DIR="/tmp/unzip"
TMP_ADDON="$UNZIP_DIR/tmp_addon"
TMP_SYS="$UNZIP_DIR/tmp_sys"
TMP_PRIV="$UNZIP_DIR/tmp_priv"
TMP_SYS_OPT="$UNZIP_DIR/tmp_sys_opt"
TMP_PRIV_OPT="$UNZIP_DIR/tmp_priv_opt"
TMP_LIB="$UNZIP_DIR/tmp_lib"
TMP_LIB64="$UNZIP_DIR/tmp_lib64"
TMP_FRAMEWORK="$UNZIP_DIR/tmp_framework"
TMP_PRIV_PERM="$UNZIP_DIR/tmp_priv_perm"
TMP_CONFIG="$UNZIP_DIR/tmp_config"
TMP_DEFAULT_PERM="$UNZIP_DIR/tmp_default"
TMP_G_PERM="$UNZIP_DIR/tmp_perm"
TMP_G_PREF="$UNZIP_DIR/tmp_pref"
SYSTEM_APP="$SYSTEM/app"
SYSTEM_PRIV_APP="$SYSTEM/priv-app"
SYSTEM_LIB="$SYSTEM/lib"
SYSTEM_LIB64="$SYSTEM/lib64"
SYSTEM_ADDOND="$SYSTEM/addon.d"
SYSTEM_FRAMEWORK="$SYSTEM/framework"
SYSTEM_ETC_CONFIG="$SYSTEM/etc/sysconfig"
SYSTEM_ETC_DEFAULT="$SYSTEM/etc/default-permissions"
SYSTEM_ETC_PERM="$SYSTEM/etc/permissions"
SYSTEM_ETC_PREF="$SYSTEM/etc/preferred-apps"
EXTRA_LOG="/cache/bitgapps/extra.log"
SQLITE_LOG="/cache/bitgapps/sqlite.log"
SQLITE_TOOL="/tmp/sqlite3"

if [ -d "$LOGD" ]; then
   echo "- Log directory found in :" $TEMP
else
   echo "- Log directory not found in :" $TEMP
   echo "- Creating in :" $TEMP
   mkdir /cache/bitgapps
   chmod 1755 /cache/bitgapps
   echo "- Done"
fi

# Creating installation components
service_manager() {
 echo "-----------------------------------" >> $LOG
 echo " --- BiTGApps Installation Log --- " >> $LOG
 echo "             Start at              " >> $LOG
 echo "        $( date +"%m-%d-%Y %H:%M:%S" )" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo " " >> $LOG
 echo "-----------------------------------" >> $LOG
 if [ -d "$LOGD" ]; then
    echo "- Log directory found in :" $TEMP >> $LOG
 else
    echo "- Log directory not found in" $TEMP >> $LOG
 fi
 echo "-----------------------------------" >> $LOG
 if [ -d "$UNZIP_DIR" ]; then
    echo "- Unzip directory found in :" $TMP >> $LOG
    echo "- Creating components in :" $TMP >> $LOG
    mkdir $UNZIP_DIR/tmp_addon
    mkdir $UNZIP_DIR/tmp_sys
    mkdir $UNZIP_DIR/tmp_priv
    mkdir $UNZIP_DIR/tmp_lib
    mkdir $UNZIP_DIR/tmp_lib64
    mkdir $UNZIP_DIR/tmp_framework
    mkdir $UNZIP_DIR/tmp_priv_perm
    mkdir $UNZIP_DIR/tmp_config
    mkdir $UNZIP_DIR/tmp_default
    mkdir $UNZIP_DIR/tmp_perm
    mkdir $UNZIP_DIR/tmp_pref
    chmod 0755 $UNZIP_DIR
    chmod 0755 $UNZIP_DIR/tmp_addon
    chmod 0755 $UNZIP_DIR/tmp_sys
    chmod 0755 $UNZIP_DIR/tmp_priv
    chmod 0755 $UNZIP_DIR/tmp_lib
    chmod 0755 $UNZIP_DIR/tmp_lib64
    chmod 0755 $UNZIP_DIR/tmp_framework
    chmod 0755 $UNZIP_DIR/tmp_priv_perm
    chmod 0755 $UNZIP_DIR/tmp_config
    chmod 0755 $UNZIP_DIR/tmp_default
    chmod 0755 $UNZIP_DIR/tmp_perm
    chmod 0755 $UNZIP_DIR/tmp_pref
 else
   echo "- Unzip directory not found in :" $TMP >> $LOG
 fi
}

# Removing pre-installed system files
pre_installed() {
 rm -rf $SYSTEM/app/Calendar
 rm -rf $SYSTEM/app/FaceLock
 rm -rf $SYSTEM/app/GoogleContactsSyncAdapter
 rm -rf $SYSTEM/app/GoogleExtShared
 rm -rf $SYSTEM/app/ExtShared
 rm -rf $SYSTEM/app/MarkupGoogle
 rm -rf $SYSTEM/app/SoundPickerPrebuilt
 rm -rf $SYSTEM/priv-app/AndroidPlatformServices
 rm -rf $SYSTEM/priv-app/CarrierSetup
 rm -rf $SYSTEM/priv-app/ConfigUpdater
 rm -rf $SYSTEM/priv-app/GmsCoreSetupPrebuilt
 rm -rf $SYSTEM/priv-app/GoogleBackupTransport
 rm -rf $SYSTEM/priv-app/GoogleExtServices
 rm -rf $SYSTEM/priv-app/ExtServices
 rm -rf $SYSTEM/priv-app/GoogleRestore
 rm -rf $SYSTEM/priv-app/GoogleOneTimeInitializer
 rm -rf $SYSTEM/priv-app/OneTimeInitializer
 rm -rf $SYSTEM/priv-app/GoogleServicesFramework
 rm -rf $SYSTEM/priv-app/Phonesky
 rm -rf $SYSTEM/priv-app/PrebuiltGmsCorePi
 rm -rf $SYSTEM/priv-app/WellbeingPrebuilt
 rm -rf $SYSTEM/framework/com.google.android.dialer.support.jar
 rm -rf $SYSTEM/framework/com.google.android.maps.jar
 rm -rf $SYSTEM/framework/com.google.android.media.effects.jar
 rm -rf $SYSTEM/lib/libfilterpack_facedetect.so
 rm -rf $SYSTEM/lib/libfrsdk.so
 rm -rf $SYSTEM/lib64/libbarhopper.so
 rm -rf $SYSTEM/lib64/libfacenet.so
 rm -rf $SYSTEM/lib64/libfilterpack_facedetect.so
 rm -rf $SYSTEM/lib64/libfrsdk.so
 rm -rf $SYSTEM/lib64/libjni_latinimegoogle.so
 rm -rf $SYSTEM/lib64/libsketchology_native.so
 rm -rf $SYSTEM/etc/permissions/com.google.android.dialer.support.xml
 rm -rf $SYSTEM/etc/permissions/com.google.android.maps.xml
 rm -rf $SYSTEM/etc/permissions/com.google.android.media.effects.xml
 rm -rf $SYSTEM/etc/permissions/privapp-permissions-google.xml
 rm -rf $SYSTEM/etc/preferred-apps
 rm -rf $SYSTEM/etc/sysconfig/dialer_experience.xml
 rm -rf $SYSTEM/etc/sysconfig/google.xml
 rm -rf $SYSTEM/etc/sysconfig/google_build.xml
 rm -rf $SYSTEM/etc/sysconfig/google_exclusives_enable.xml
 rm -rf $SYSTEM/etc/sysconfig/google-hiddenapi-package-whitelist.xml
 rm -rf $SYSTEM/etc/default-permissions
 rm -rf $SYSTEM/etc/g.prop
 rm -rf $SYSTEM/addon.d/90bit_gapps.sh
 rm -rf $SYSTEM/xbin/pm.sh
}

# Unpack system files
extract_app() {
 echo "-----------------------------------" >> $LOG
 echo "- Unpack SYS-APP Files" >> $LOG
 unzip -o $ZIP_FILE/sys/sys_app_FaceLock.zip -d $TMP_SYS >> $LOG
 unzip -o $ZIP_FILE/sys/sys_app_GoogleContactsSyncAdapter.zip -d $TMP_SYS >> $LOG
 unzip -o $ZIP_FILE/sys/sys_app_GoogleExtShared.zip -d $TMP_SYS >> $LOG
 unzip -o $ZIP_FILE/sys/sys_app_MarkupGoogle.zip -d $TMP_SYS >> $LOG
 echo "- Done" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "- Unpack PRIV-APP Files" >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_AndroidPlatformServices.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_CarrierSetup.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_ConfigUpdater.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_GmsCoreSetupPrebuilt.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_GoogleBackupTransport.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_GoogleExtServices.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_GoogleServicesFramework.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_Phonesky.zip -d $TMP_PRIV >> $LOG
 unzip -o $ZIP_FILE/core/priv_app_PrebuiltGmsCorePi.zip -d $TMP_PRIV >> $LOG
 echo "- Done" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "- Unpack Framework Files" >> $LOG
 unzip -o $ZIP_FILE/sys_Framework.zip -d $TMP_FRAMEWORK >> $LOG
 echo "- Done" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "- Unpack System Lib" >> $LOG
 unzip -o $ZIP_FILE/sys_Lib.zip -d $TMP_LIB >> $LOG
 echo "- Done" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "- Unpack System Lib64" >> $LOG
 unzip -o $ZIP_FILE/sys_Lib64.zip -d $TMP_LIB64 >> $LOG
 echo "- Done" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "- Unpack System Files" >> $LOG
 unzip -o $ZIP_FILE/sys_Config_Permission.zip -d $TMP_CONFIG >> $LOG
 unzip -o $ZIP_FILE/sys_Default_Permission.zip -d $TMP_DEFAULT_PERM >> $LOG
 unzip -o $ZIP_FILE/sys_Permissions.zip -d $TMP_G_PERM >> $LOG
 unzip -o $ZIP_FILE/sys_Pref_Permission.zip -d $TMP_G_PREF >> $LOG
 echo "- Done" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "- Unpack Boot Script" >> $LOG
 unzip -o $ZIP_FILE/ADDOND.zip -d $TMP_ADDON >> $LOG
 echo "- Done" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "- Installation Complete" >> $LOG
 echo "-----------------------------------" >> $LOG
 echo "Finish at $( date +"%m-%d-%Y %H:%M:%S" )" >> $LOG
 echo "-----------------------------------" >> $LOG
}

#
# SQLite database vaccum
#
# SQLite3 for ARM aarch64
# Version: SQLite 3.27.2
#
# Frequent inserts, updates, and deletes can cause the database file to become fragmented,
# where data for a single table or index is scattered around the database file.
# Running VACUUM ensures that each table and index is largely stored contiguously within the database file.
# In some cases, VACUUM may also reduce the number of partially filled pages in the database, reducing the size of the database file further.
database_optimization() {
 echo "SQLite database VACUUM and REINDEX started at $( date +"%m-%d-%Y %H:%M:%S" )" >> $SQLITE_LOG;
   for i in `find /d* -iname "*.db"`; do
      $SQLITE_TOOL $i 'VACUUM;';
      resVac=$?
        if [ $resVac == 0 ]; then
           resVac="SUCCESS";
        else
           resVac="ERRCODE-$resVac";
        fi;
      $SQLITE_TOOL $i 'REINDEX;';
      resIndex=$?
        if [ $resIndex == 0 ]; then
           resIndex="SUCCESS";
        else
           resIndex="ERRCODE-$resIndex";
        fi;
      echo "Database $i:  VACUUM=$resVac  REINDEX=$resIndex" >> $SQLITE_LOG;
   done
 echo "SQLite database VACUUM and REINDEX finished at $( date +"%m-%d-%Y %H:%M:%S" )" >> $SQLITE_LOG;
}

# Setup g-apps build dependency
extra_install() {
 if [ -d "$SYSTEM_ETC_PREF" ]; then
    echo "- Build dependency found : /system" >> $EXTRA_LOG;
 else
    echo "- Build dependency not found in : /system" >> $EXTRA_LOG;
    echo "- Creating in : /system" >> $EXTRA_LOG;
    mkdir $SYSTEM/etc/preferred-apps
    chmod 0755 $SYSTEM/etc/preferred-apps
    echo "- Done" >> $EXTRA_LOG;
 fi
 echo "-----------------------------------" >> $EXTRA_LOG;
 if [ -d "$SYSTEM_ETC_DEFAULT" ]; then
    echo "- Build dependency found : /system" >> $EXTRA_LOG;
 else
    echo "- Build dependency not found in : /system" >> $EXTRA_LOG;
    echo "- Creating in : /system" >> $EXTRA_LOG;
    mkdir $SYSTEM/etc/default-permissions
    chmod 0755 $SYSTEM/etc/default-permissions
    echo "- Done" >> $EXTRA_LOG;
 fi
}

selinux_context_s1() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/FaceLock";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/GoogleContactsSyncAdapter";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/GoogleExtShared";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/MarkupGoogle";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/FaceLock/FaceLock.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/GoogleExtShared/GoogleExtShared.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_APP/MarkupGoogle/MarkupGoogle.apk";
}

selinux_context_sp2() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/AndroidPlatformServices";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/CarrierSetup";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/ConfigUpdater";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GmsCoreSetupPrebuilt";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GoogleBackupTransport";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GoogleExtServices";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GoogleServicesFramework";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Phonesky";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/PrebuiltGmsCorePi";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/AndroidPlatformServices/AndroidPlatformServices.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/CarrierSetup/CarrierSetup.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/ConfigUpdater/ConfigUpdater.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GoogleBackupTransport/GoogleBackupTransport.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GoogleExtServices/GoogleExtServices.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/GoogleServicesFramework/GoogleServicesFramework.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/Phonesky/Phonesky.apk";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP/PrebuiltGmsCorePi/PrebuiltGmsCorePi.apk";
}

selinux_context_sf3() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM_FRAMEWORK/com.google.android.dialer.support.jar";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_FRAMEWORK/com.google.android.maps.jar";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_FRAMEWORK/com.google.android.media.effects.jar";
}

selinux_context_sl4() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB/libfilterpack_facedetect.so";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB/libfrsdk.so";
}

selinux_context_sl5() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB64/libbarhopper.so";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB64/libfacenet.so";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB64/libfilterpack_facedetect.so";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB64/libfrsdk.so";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB64/libjni_latinimegoogle.so";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB64/libsketchology_native.so";
}

selinux_context_se6() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM/etc/default-permissions";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_DEFAULT/default-permissions.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_DEFAULT/opengapps-permissions.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_PERM/com.google.android.dialer.support.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_PERM/com.google.android.maps.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_PERM/com.google.android.media.effects.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_PERM/privapp-permissions-google.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM/etc/preferred-apps";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_PREF/google.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_CONFIG/dialer_experience.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_CONFIG/google.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_CONFIG/google_build.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_CONFIG/google_exclusives_enable.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_CONFIG/google-hiddenapi-package-whitelist.xml";
 chcon -h u:object_r:system_file:s0 "$SYSTEM/etc/g.prop";
}

selinux_context_sb7() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM_ADDOND/90bit_gapps.sh";
}

selinux_context_sxb8() {
 chcon -h u:object_r:system_file:s0 "$SYSTEM/xbin/pm.sh";
}

## End selinux method

# Complete the installation in sparse package format
send_sparse_1() {
 file_list="$(find "$TMP_SYS/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_SYS/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_SYS/${file}" "$SYSTEM_APP/${file}"
     chmod 0644 "$SYSTEM_APP/${file}";
 done
 for dir in $dir_list; do
     chmod 0755 "$SYSTEM_APP/${dir}";
 done
}

send_sparse_2() {
 file_list="$(find "$TMP_PRIV/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_PRIV/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_PRIV/${file}" "$SYSTEM_PRIV_APP/${file}"
     chmod 0644 "$SYSTEM_PRIV_APP/${file}";
 done
 for dir in $dir_list; do
     chmod 0755 "$SYSTEM_PRIV_APP/${dir}";
 done
}

send_sparse_3() {
 file_list="$(find "$TMP_FRAMEWORK/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_FRAMEWORK/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_FRAMEWORK/${file}" "$SYSTEM_FRAMEWORK/${file}"
     chmod 0644 "$SYSTEM_FRAMEWORK/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_FRAMEWORK/${dir}";
 done
}

send_sparse_4() {
 file_list="$(find "$TMP_LIB/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_LIB/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_LIB/${file}" "$SYSTEM_LIB/${file}"
     chmod 0644 "$SYSTEM_LIB/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_LIB/${dir}";
 done
}

send_sparse_5() {
 file_list="$(find "$TMP_LIB64/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_LIB64/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_LIB64/${file}" "$SYSTEM_LIB64/${file}"
     chmod 0644 "$SYSTEM_LIB64/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_LIB64/${dir}";
 done
}

send_sparse_6() {
 file_list="$(find "$TMP_CONFIG/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_CONFIG/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_CONFIG/${file}" "$SYSTEM_ETC_CONFIG/${file}"
     chmod 0644 "$SYSTEM_ETC_CONFIG/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_ETC_CONFIG/${dir}";
 done
}

send_sparse_7() {
 file_list="$(find "$TMP_DEFAULT_PERM/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_DEFAULT_PERM/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_DEFAULT_PERM/${file}" "$SYSTEM_ETC_DEFAULT/${file}"
     chmod 0644 "$SYSTEM_ETC_DEFAULT/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_ETC_DEFAULT/${dir}";
 done
}

send_sparse_8() {
 file_list="$(find "$TMP_G_PREF/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_G_PREF/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_G_PREF/${file}" "$SYSTEM_ETC_PREF/${file}"
     chmod 0644 "$SYSTEM_ETC_PREF/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_ETC_PREF/${dir}";
 done
}

send_sparse_9() {
 file_list="$(find "$TMP_G_PERM/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_G_PERM/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_G_PERM/${file}" "$SYSTEM_ETC_PERM/${file}"
     chmod 0644 "$SYSTEM_ETC_PERM/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_ETC_PERM/${dir}";
 done
}

send_sparse_10() {
 file_list="$(find "$TMP_ADDON/" -mindepth 1 -type f | cut -d/ -f5-)"
 dir_list="$(find "$TMP_ADDON/" -mindepth 1 -type d | cut -d/ -f5-)"
 for file in $file_list; do
     install -D "$TMP_ADDON/${file}" "$SYSTEM_ADDOND/${file}"
     chmod 0644 "$SYSTEM_ADDOND/${file}";
 done
 for dir in $dir_list; do
   chmod 0755 "$SYSTEM_ADDOND/${dir}";
 done
}

send_sparse_11() {
 cp -f $TMP/g.prop $SYSTEM/etc/g.prop
 chmod 0644 $SYSTEM/etc/g.prop
}

#
# Disable Find My Device (in order to have optimized GMS for Android 9 or later)
#
# Copyright © 2019 GL-DP, gloeyisk
# Github: Gloeyisk <gloeyisk@gmail.com>
# License: GPL v2
#
# Usage
#
# To optimize core package:
#
# Input:
#      X : Install and Open Android Terminal Emulator
#      X : Type 'su'
#      X : Type 'pm.sh
#
# Output:
#      X : Component {com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver}
#          new state: disabled
#
# Force Battery Optimization for GMS Core and its components
allow_force_opt() {
 cp -f $TMP/pm.sh $SYSTEM/xbin/pm.sh
 chmod 0755 $SYSTEM/xbin/pm.sh
}

# execute installation functions
service_manager;
pre_installed;
extra_install;
extract_app;
# sending packages in sparse mode
send_sparse_1;
send_sparse_2;
send_sparse_3;
send_sparse_4;
send_sparse_5;
send_sparse_6;
send_sparse_7;
send_sparse_8;
send_sparse_9;
send_sparse_10;
send_sparse_11;
allow_force_opt;
# execute selinux install functions
selinux_context_s1;
selinux_context_sp2;
selinux_context_sf3;
selinux_context_sl4;
selinux_context_sl5;
selinux_context_se6;
selinux_context_sb7;
selinux_context_sxb8;
# optimize application database
database_optimization;

## End method
