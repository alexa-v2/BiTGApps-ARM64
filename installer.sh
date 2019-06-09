#!/sbin/sh
#
##############################################################
# File name       : installer.sh
#
# Requirement     : Magisk
#
# Description     : Installation script for BiTGApps
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

align_apk() {
  PATH="/tmp/install:$PATH" $BB ash zipalign.sh $2;
}

# load data from security file
. /tmp/install/selinux_context.sh;

#
#
# The below code is obsolete now and not functional any more.
# It create random problems in several devices and ended up with,
# build fails.
#
# linker: CANNOT LINK EXECUTABLE "/system/bin/sh":
#  cannot locate symbol "nl_langinfo" referenced by "/system/bin/sh"...
# linker: CANNOT LINK EXECUTABLE "/system/bin/sh":
#  cannot locate symbol "nl_langinfo" referenced by "/system/bin/sh"...
#    
# run_program("/sbin/busybox", "mount", "/system");
# run_program("/tmp/installer.sh");
#
#
# Replaced with below code. More universal and use recovery components.
#
# // Define partition state //
#  ifelse(is_mounted("/system"), unmount("/system"));
# // Use block device for writing into system //
#  mount("ext4", "EMMC", "/dev/block/bootdevice/by-name/system", "/system");
# // Must define tag here //
#  run_program("/sbin/sh", "-C", "/tmp/installer.sh");
#
# // Both codes are obsolete for new installer //
# //    Saturday March 30 15:20:09 IST 2019    //
#

# dependencies
TEMP="/cache"
TMP="/tmp/install"
LOGD="/cache/bitgapps"
LOG="/cache/bitgapps/installation.log"
ZIP_FILE="/tmp/install/zip"
UNZIP_DIR="/tmp/install/unzip"
TMP_ADDON="$UNZIP_DIR/tmp_addon"
TMP_SYS="$UNZIP_DIR/tmp_sys"
TMP_PRIV="$UNZIP_DIR/tmp_priv"
TMP_LIB="$UNZIP_DIR/tmp_lib"
TMP64="$UNZIP_DIR/tmp_lib64"
TMP_FRAMEWORK="$UNZIP_DIR/tmp_framework"
TMP_PRIV_PERM="$UNZIP_DIR/tmp_priv_perm"
TMP_CONFIG="$UNZIP_DIR/tmp_config"
TMP_DEFAULT_PERM="$UNZIP_DIR/tmp_default"
TMP_G_PERM="$UNZIP_DIR/tmp_perm"
TMP_G_PREF="$UNZIP_DIR/tmp_pref"

# log
if [ -d "$LOGD" ]; then
   echo "- Log directory found in :" $TEMP
else
   echo "- Log directory not found in :" $TEMP
   echo "- Creating in :" $TEMP
   mkdir /cache/bitgapps
   chmod 1755 /cache/bitgapps
   echo "- Done"
fi

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
echo "-----------------------------------" >> $LOG
echo "- Unpack SYS-APP Files" >> $LOG
$BB unzip -l $ZIP_FILE/sys/sys_app_FaceLock.zip >> $LOG
$BB unzip -l $ZIP_FILE/sys/sys_app_GoogleContactsSyncAdapter.zip >> $LOG
$BB unzip -l $ZIP_FILE/sys/sys_app_GoogleExtShared.zip >> $LOG
$BB unzip -l $ZIP_FILE/sys/sys_app_MarkupGoogle.zip >> $LOG
$BB unzip -l $ZIP_FILE/sys/sys_app_SoundPickerPrebuilt.zip >> $LOG
$BB unzip -o $ZIP_FILE/sys/sys_app_FaceLock.zip -d $TMP_SYS >> $LOG
$BB unzip -o $ZIP_FILE/sys/sys_app_GoogleContactsSyncAdapter.zip -d $TMP_SYS >> $LOG
$BB unzip -o $ZIP_FILE/sys/sys_app_GoogleExtShared.zip -d $TMP_SYS >> $LOG
$BB unzip -o $ZIP_FILE/sys/sys_app_MarkupGoogle.zip -d $TMP_SYS >> $LOG
$BB unzip -o $ZIP_FILE/sys/sys_app_SoundPickerPrebuilt.zip -d $TMP_SYS >> $LOG
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Unpack PRIV-APP Files" >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_AndroidPlatformServices.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_CarrierSetup.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_ConfigUpdater.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_GmsCoreSetupPrebuilt.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_GoogleBackupTransport.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_GoogleExtServices.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_GoogleRestore.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_GoogleServicesFramework.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_Phonesky.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_PrebuiltGmsCorePi.zip >> $LOG
$BB unzip -l $ZIP_FILE/core/priv_app_WellbeingPrebuilt.zip >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_AndroidPlatformServices.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_CarrierSetup.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_ConfigUpdater.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_GmsCoreSetupPrebuilt.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_GoogleBackupTransport.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_GoogleExtServices.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_GoogleRestore.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_GoogleServicesFramework.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_Phonesky.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_PrebuiltGmsCorePi.zip -d $TMP_PRIV >> $LOG
$BB unzip -o $ZIP_FILE/core/priv_app_WellbeingPrebuilt.zip -d $TMP_PRIV >> $LOG
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Optimized APK Files" >> $LOG
# // Zipalign APK files before pushing into system //
align_apk
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Installing SYS-APP Files" >> $LOG
echo "- Change Selinux Security Context" >> $LOG
# // Change Selinux Security Context before pushing into system //
selinux_context_s1
echo "- Removing Pre-installed files" >> $LOG
$BB rm -rf /system/app/FaceLock
$BB rm -rf /system/app/GoogleContactsSyncAdapter
$BB rm -rf /system/app/GoogleExtShared
$BB rm -rf /system/app/ExtShared
$BB rm -rf /system/app/MarkupGoogle
$BB rm -rf /system/app/SoundPickerPrebuilt
echo "- Installing APK" >> $LOG
$BB mv -f $TMP_SYS/FaceLock /system/app
$BB mv -f $TMP_SYS/GoogleContactsSyncAdapter /system/app
$BB mv -f $TMP_SYS/GoogleExtShared /system/app
$BB mv -f $TMP_SYS/MarkupGoogle /system/app
$BB mv -f $TMP_SYS/SoundPickerPrebuilt /system/app
echo "- Set Permission" >> $LOG
chmod 0755 /system/app/FaceLock
chmod 0755 /system/app/FaceLock/lib
chmod 0755 /system/app/FaceLock/lib/arm64
chmod 0755 /system/app/GoogleContactsSyncAdapter
chmod 0755 /system/app/GoogleExtShared
chmod 0755 /system/app/MarkupGoogle
chmod 0755 /system/app/SoundPickerPrebuilt
echo "- Set APK Permission" >> $LOG
chmod 0644 /system/app/FaceLock/FaceLock.apk
chmod 0644 /system/app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
chmod 0644 /system/app/GoogleExtShared/GoogleExtShared.apk
chmod 0644 /system/app/MarkupGoogle/MarkupGoogle.apk
chmod 0644 /system/app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Installing PRIV-APP Files" >> $LOG
echo "- Change Selinux Security Context" >> $LOG
# // Change Selinux Security Context before pushing into system //
selinux_context_sp2
echo "- Removing Pre-installed files" >> $LOG
$BB rm -rf /system/priv-app/AndroidPlatformServices
$BB rm -rf /system/priv-app/CarrierSetup
$BB rm -rf /system/priv-app/ConfigUpdater
$BB rm -rf /system/priv-app/GmsCoreSetupPrebuilt
$BB rm -rf /system/priv-app/GoogleBackupTransport
$BB rm -rf /system/priv-app/GoogleExtServices
$BB rm -rf /system/priv-app/ExtServices
$BB rm -rf /system/priv-app/GoogleRestore
$BB rm -rf /system/priv-app/GoogleServicesFramework
$BB rm -rf /system/priv-app/Phonesky
$BB rm -rf /system/priv-app/PrebuiltGmsCorePi
$BB rm -rf /system/priv-app/WellbeingPrebuilt
echo "- Installing APK" >> $LOG
$BB mv -f $TMP_PRIV/AndroidPlatformServices /system/priv-app
$BB mv -f $TMP_PRIV/CarrierSetup /system/priv-app
$BB mv -f $TMP_PRIV/ConfigUpdater /system/priv-app
$BB mv -f $TMP_PRIV/GmsCoreSetupPrebuilt /system/priv-app
$BB mv -f $TMP_PRIV/GoogleBackupTransport /system/priv-app
$BB mv -f $TMP_PRIV/GoogleExtServices /system/priv-app
$BB mv -f $TMP_PRIV/GoogleRestore /system/priv-app
$BB mv -f $TMP_PRIV/GoogleServicesFramework /system/priv-app
$BB mv -f $TMP_PRIV/Phonesky /system/priv-app
$BB mv -f $TMP_PRIV/PrebuiltGmsCorePi /system/priv-app
$BB mv -f $TMP_PRIV/WellbeingPrebuilt /system/priv-app
echo "- Set Permission" >> $LOG
chmod 0755 /system/priv-app/AndroidPlatformServices
chmod 0755 /system/priv-app/CarrierSetup
chmod 0755 /system/priv-app/ConfigUpdater
chmod 0755 /system/priv-app/GmsCoreSetupPrebuilt
chmod 0755 /system/priv-app/GoogleBackupTransport
chmod 0755 /system/priv-app/GoogleExtServices
chmod 0755 /system/priv-app/GoogleRestore
chmod 0755 /system/priv-app/GoogleServicesFramework
chmod 0755 /system/priv-app/Phonesky
chmod 0755 /system/priv-app/PrebuiltGmsCorePi
chmod 0755 /system/priv-app/WellbeingPrebuilt
echo "- Set APK Permission" >> $LOG
chmod 0644 /system/priv-app/AndroidPlatformServices/AndroidPlatformServices.apk
chmod 0644 /system/priv-app/CarrierSetup/CarrierSetup.apk
chmod 0644 /system/priv-app/ConfigUpdater/ConfigUpdater.apk
chmod 0644 /system/priv-app/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk
chmod 0644 /system/priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
chmod 0644 /system/priv-app/GoogleExtServices/GoogleExtServices.apk
chmod 0644 /system/priv-app/GoogleRestore/GoogleRestore.apk
chmod 0644 /system/priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
chmod 0644 /system/priv-app/Phonesky/Phonesky.apk
chmod 0644 /system/priv-app/PrebuiltGmsCorePi/PrebuiltGmsCorePi.apk
chmod 0644 /system/priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Unpack Framework Files" >> $LOG
$BB unzip -l $ZIP_FILE/sys_Framework.zip >> $LOG
$BB unzip -o $ZIP_FILE/sys_Framework.zip -d $TMP_FRAMEWORK >> $LOG
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Installing Framework Files" >> $LOG
echo "- Change Selinux Security Context" >> $LOG
# // Change Selinux Security Context before pushing into system //
selinux_context_sf3
echo "- Removing Pre-installed files" >> $LOG
$BB rm -rf /system/framework/com.google.android.dialer.support.jar
$BB rm -rf /system/framework/com.google.android.maps.jar
$BB rm -rf /system/framework/com.google.android.media.effects.jar
$BB rm -rf /system/framework/com.google.widevine.software.drm.jar
echo "- Installing Framework" >> $LOG
$BB mv -f $TMP_FRAMEWORK/com.google.android.dialer.support.jar /system/framework
$BB mv -f $TMP_FRAMEWORK/com.google.android.maps.jar /system/framework
$BB mv -f $TMP_FRAMEWORK/com.google.android.media.effects.jar /system/framework
echo "- Set Permission" >> $LOG
chmod 0644 /system/framework/com.google.android.dialer.support.jar
chmod 0644 /system/framework/com.google.android.maps.jar
chmod 0644 /system/framework/com.google.android.media.effects.jar
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Unpack System Lib" >> $LOG
$BB unzip -l $ZIP_FILE/sys_Lib.zip >> $LOG
$BB unzip -o $ZIP_FILE/sys_Lib.zip -d $TMP_LIB >> $LOG
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Installing System Library Files" >> $LOG
echo "- Change Selinux Security Context" >> $LOG
# // Change Selinux Security Context before pushing into system //
selinux_context_sl4
echo "- Removing Pre-installed files" >> $LOG
$BB rm -rf /system/lib/libfilterpack_facedetect.so
$BB rm -rf /system/lib/libfrsdk.so
echo "- Installing Lib" >> $LOG
$BB mv -f $TMP_LIB/libfilterpack_facedetect.so /system/lib
$BB mv -f $TMP_LIB/libfrsdk.so /system/lib
echo "- Set Permission" >> $LOG
chmod 0644 /system/lib/libfilterpack_facedetect.so
chmod 0644 /system/lib/libfrsdk.so
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Unpack System Lib64" >> $LOG
$BB unzip -l $ZIP_FILE/sys_Lib64.zip >> $LOG
$BB unzip -o $ZIP_FILE/sys_Lib64.zip -d $TMP64 >> $LOG
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Installing System Library64 Files" >> $LOG
echo "- Change Selinux Security Context" >> $LOG
# // Change Selinux Security Context before pushing into system //
selinux_context_sl5
echo "- Removing Pre-installed files" >> $LOG
$BB rm -rf /system/lib64/libbarhopper.so
$BB rm -rf /system/lib64/libfacenet.so
$BB rm -rf /system/lib64/libfilterpack_facedetect.so
$BB rm -rf /system/lib64/libfrsdk.so
$BB rm -rf /system/lib64/libjni_latinimegoogle.so
$BB rm -rf /system/lib64/libsketchology_native.so
echo "- Installing Lib64" >> $LOG
$BB mv -f $TMP64/libbarhopper.so /system/lib64
$BB mv -f $TMP64/libfacenet.so /system/lib64
## Link faceunlock library
$BB ln -sfnv /system/lib64/libfacenet.so /system/app/FaceLock/lib/arm64
$BB rm -rf /system/app/FaceLock/lib/arm64/placeholder
## Link faceunlock library
$BB mv -f $TMP64/libfilterpack_facedetect.so /system/lib64
$BB mv -f $TMP64/libfrsdk.so /system/lib64
$BB mv -f $TMP64/libjni_latinimegoogle.so /system/lib64
$BB mv -f $TMP64/libsketchology_native.so /system/lib64
echo "- Set Permission" >> $LOG
chmod 0644 /system/lib64/libbarhopper.so
chmod 0644 /system/lib64/libfacenet.so
chmod 0644 /system/lib64/libfilterpack_facedetect.so
chmod 0644 /system/lib64/libfrsdk.so
chmod 0644 /system/lib64/libjni_latinimegoogle.so
chmod 0644 /system/lib64/libsketchology_native.so
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Unpack System Files" >> $LOG
$BB unzip -l $ZIP_FILE/sys_Config_Permission.zip >> $LOG
$BB unzip -l $ZIP_FILE/sys_Default_Permission.zip >> $LOG
$BB unzip -l $ZIP_FILE/sys_Permissions.zip >> $LOG
$BB unzip -l $ZIP_FILE/sys_Pref_Permission.zip >> $LOG
$BB unzip -o $ZIP_FILE/sys_Config_Permission.zip -d $TMP_CONFIG >> $LOG
$BB unzip -o $ZIP_FILE/sys_Default_Permission.zip -d $TMP_DEFAULT_PERM >> $LOG
$BB unzip -o $ZIP_FILE/sys_Permissions.zip -d $TMP_G_PERM >> $LOG
$BB unzip -o $ZIP_FILE/sys_Pref_Permission.zip -d $TMP_G_PREF >> $LOG
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Installing System Files" >> $LOG
echo "- Removing Pre-installed files" >> $LOG
$BB rm -rf /system/etc/permissions/com.google.android.dialer.support.xml
$BB rm -rf /system/etc/permissions/com.google.android.maps.xml
$BB rm -rf /system/etc/permissions/com.google.android.media.effects.xml
$BB rm -rf /system/etc/permissions/com.google.widevine.software.drm.xml
$BB rm -rf /system/etc/permissions/privapp-permissions-google.xml
$BB rm -rf /system/etc/preferred-apps
$BB rm -rf /system/etc/sysconfig/dialer_experience.xml
$BB rm -rf /system/etc/sysconfig/google.xml
$BB rm -rf /system/etc/sysconfig/google_build.xml
$BB rm -rf /system/etc/sysconfig/google_exclusives_enable.xml
$BB rm -rf /system/etc/sysconfig/google-hiddenapi-package-whitelist.xml
$BB rm -rf /system/etc/sysconfig/whitelist_com.android.omadm.service.xml
$BB rm -rf /system/etc/default-permissions
echo "- Creating Google Dependency" >> $LOG
mkdir /system/etc/preferred-apps
chmod 0755 /system/etc/preferred-apps
mkdir /system/etc/default-permissions
chmod 0755 /system/etc/default-permissions
echo "- Change Selinux Security Context" >> $LOG
# // Change Selinux Security Context before pushing into system //
selinux_context_se6
echo "- Installing" >> $LOG
$BB mv -f $TMP_G_PERM/com.google.android.dialer.support.xml /system/etc/permissions
$BB mv -f $TMP_G_PERM/com.google.android.maps.xml /system/etc/permissions
$BB mv -f $TMP_G_PERM/com.google.android.media.effects.xml /system/etc/permissions
$BB mv -f $TMP_G_PERM/privapp-permissions-google.xml /system/etc/permissions
$BB mv -f $TMP_CONFIG/dialer_experience.xml /system/etc/sysconfig
$BB mv -f $TMP_CONFIG/google.xml /system/etc/sysconfig
$BB mv -f $TMP_CONFIG/google_build.xml /system/etc/sysconfig
$BB mv -f $TMP_CONFIG/google_exclusives_enable.xml /system/etc/sysconfig
$BB mv -f $TMP_CONFIG/google-hiddenapi-package-whitelist.xml /system/etc/sysconfig
$BB mv -f $TMP_DEFAULT_PERM/default-permissions.xml /system/etc/default-permissions
$BB mv -f $TMP_DEFAULT_PERM/opengapps-permissions.xml /system/etc/default-permissions
$BB mv -f $TMP_G_PREF/google.xml /system/etc/preferred-apps
$BB mv -f $ZIP_FILE/g.prop /system/etc
echo "- Set Permission" >> $LOG
chmod 0644 /system/etc/default-permissions/default-permissions.xml
chmod 0644 /system/etc/default-permissions/opengapps-permissions.xml
chmod 0644 /system/etc/permissions/com.google.android.dialer.support.xml
chmod 0644 /system/etc/permissions/com.google.android.maps.xml
chmod 0644 /system/etc/permissions/com.google.android.media.effects.xml
chmod 0644 /system/etc/permissions/privapp-permissions-google.xml
chmod 0644 /system/etc/preferred-apps/google.xml
chmod 0644 /system/etc/sysconfig/dialer_experience.xml
chmod 0644 /system/etc/sysconfig/google.xml
chmod 0644 /system/etc/sysconfig/google_build.xml
chmod 0644 /system/etc/sysconfig/google_exclusives_enable.xml
chmod 0644 /system/etc/sysconfig/google-hiddenapi-package-whitelist.xml
chmod 0644 /system/etc/g.prop
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Unpack Boot Script" >> $LOG
$BB unzip -l $ZIP_FILE/ADDOND.zip >> $LOG
$BB unzip -o $ZIP_FILE/ADDOND.zip -d $TMP_ADDON >> $LOG
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Install Boot Script" >> $LOG
echo "- Change Selinux Security Context" >> $LOG
# // Change Selinux Security Context before pushing into system //
selinux_context_sb7
echo "- Removing Pre-installed addon.d script" >> $LOG
$BB rm -rf /system/addon.d/90bit_gapps.sh
echo "- Installing" >> $LOG
$BB mv -f $TMP_ADDON/90bit_gapps.sh /system/addon.d
echo "- Set Permission" >> $LOG
chmod 0755 /system/addon.d/90bit_gapps.sh
echo "- Done" >> $LOG
echo "-----------------------------------" >> $LOG
echo "- Installation Complete" >> $LOG
echo "-----------------------------------" >> $LOG
echo "Finish at $( date +"%m-%d-%Y %H:%M:%S" )" >> $LOG
echo "-----------------------------------" >> $LOG
}

start_service() {
  service_manager;
}
