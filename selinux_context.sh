#!/sbin/sh
#
##############################################################
# File name       : selinux_context.sh
#
# Requirement     : Magisk
#
# Description     : Change File/Folder SELinux Context
#
# Build Date      : Sunday April 21 19:37:27 IST 2019
#
# GitHub          : TheHitMan7 <krtik.vrma@gmail.com>
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2019 TheHitMan7
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
##############################################################

# load data from Set defaults
. /tmp/install/set-defaults.sh;

selinux_context_s1() {
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/FaceLock";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/FaceLock/lib";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/FaceLock/lib/arm64";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/GoogleContactsSyncAdapter";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/GoogleExtShared";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/MarkupGoogle";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/SoundPickerPrebuilt";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/FaceLock/FaceLock.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/GoogleExtShared/GoogleExtShared.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/MarkupGoogle/MarkupGoogle.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_SYS/SoundPickerPrebuilt/SoundPickerPrebuilt.apk";
}

selinux_context_sp2() {
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/AndroidPlatformServices";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/CarrierSetup";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/ConfigUpdater";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GmsCoreSetupPrebuilt";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleBackupTransport";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleExtServices";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleRestore";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleServicesFramework";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/Phonesky";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/PrebuiltGmsCorePi";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/WellbeingPrebuilt";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/AndroidPlatformServices/AndroidPlatformServices.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/CarrierSetup/CarrierSetup.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/ConfigUpdater/ConfigUpdater.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleBackupTransport/GoogleBackupTransport.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleExtServices/GoogleExtServices.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleRestore/GoogleRestore.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/GoogleServicesFramework/GoogleServicesFramework.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/Phonesky/Phonesky.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/PrebuiltGmsCorePi/PrebuiltGmsCorePi.apk";
  chcon -h u:object_r:system_file:s0 "$TMP_PRIV/WellbeingPrebuilt/WellbeingPrebuilt.apk";
}

selinux_context_sf3() {
  chcon -h u:object_r:system_file:s0 "$TMP_FRAMEWORK/com.google.android.dialer.support.jar";
  chcon -h u:object_r:system_file:s0 "$TMP_FRAMEWORK/com.google.android.maps.jar";
  chcon -h u:object_r:system_file:s0 "$TMP_FRAMEWORK/com.google.android.media.effects.jar";
}

selinux_context_sl4() {
  chcon -h u:object_r:system_file:s0 "$TMP_LIB/libfilterpack_facedetect.so";
  chcon -h u:object_r:system_file:s0 "$TMP_LIB/libfrsdk.so";
}

selinux_context_sl5() {
  chcon -h u:object_r:system_file:s0 "$TMP64/libbarhopper.so";
  chcon -h u:object_r:system_file:s0 "$TMP64/libfacenet.so";
  chcon -h u:object_r:system_file:s0 "$TMP64/libfilterpack_facedetect.so";
  chcon -h u:object_r:system_file:s0 "$TMP64/libfrsdk.so";
  chcon -h u:object_r:system_file:s0 "$TMP64/libjni_latinimegoogle.so";
  chcon -h u:object_r:system_file:s0 "$TMP64/libsketchology_native.so";
}

selinux_context_se6() {
  chcon -h u:object_r:system_file:s0 "/system/etc/preferred-apps";
  chcon -h u:object_r:system_file:s0 "/system/etc/default-permissions";
  chcon -h u:object_r:system_file:s0 "$TMP_DEFAULT_PERM/default-permissions.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_DEFAULT_PERM/opengapps-permissions.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_G_PERM/com.google.android.dialer.support.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_G_PERM/com.google.android.maps.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_G_PERM/com.google.android.media.effects.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_G_PERM/privapp-permissions-google.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_G_PREF/google.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_CONFIG/dialer_experience.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_CONFIG/google.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_CONFIG/google_build.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_CONFIG/google_exclusives_enable.xml";
  chcon -h u:object_r:system_file:s0 "$TMP_CONFIG/google-hiddenapi-package-whitelist.xml";
  chcon -h u:object_r:system_file:s0 "$ZIP_FILE/g.prop";
}

selinux_context_sb7() {
  chcon -h u:object_r:system_file:s0 "$TMP_ADDON/90bit_gapps.sh";
}

# end method
