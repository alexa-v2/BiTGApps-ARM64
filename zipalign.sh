#!/sbin/sh
#
##############################################################
# File name       : zipalign.sh
#
# Requirement     : Magisk
#
# Description     : Optimized APK with 32-bit alignment
#                   4-byte boundaries
#                   Optimized for less RAM usage
#
# Build Date      : Saturday March 30 11:48:43 IST 2019
#
# GitHub          : TheHitMan7 <krtik.vrma@gmail.com>
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2019 TheHitMan7
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
##############################################################

LOG_FILE=/cache/bitgapps/zipalign.log
zipalign=/tmp/install/tools/zipalign
SYS_APK=/tmp/install/unzip/tmp_sys
CORE_APK=/tmp/install/unzip/tmp_priv

#
# Zipalign
#
# zipalign is an archive alignment tool that provides important optimization to Android application (APK) files.
# The purpose is to ensure that all uncompressed data starts with a particular alignment relative to the start of the file.
# Specifically, it causes all uncompressed data within the APK, such as images or raw files, to be aligned on 4-byte boundaries.
# This allows all portions to be accessed directly with mmap() even if they contain binary data with alignment restrictions.
# The benefit is a reduction in the amount of RAM consumed when running the application.
#
# Usage
#
# To align infile.apk and save it as outfile.apk:
#
# zipalign [-f] [-v] <alignment> infile.apk outfile.apk
#
# To confirm the alignment of existing.apk:
#
# zipalign -c -v <alignment> existing.apk
#
# The <alignment> is an integer that defines the byte-alignment boundaries. This must always be 4 (which provides 32-bit alignment) or else it effectively does nothing.
#
# Flags:
#     -f : overwrite existing outfile.zip
#     -v : verbose output
#     -p : outfile.zip should use the same page alignment for all shared object files within infile.zip
#     -c : confirm the alignment of the given file
#
# Source : https://developer.android.com/studio/command-line/zipalign

if [ -e $LOG_FILE ]; then
    rm $LOG_FILE;
fi;

echo "Starting Automatic ZipAlign $( date +"%m-%d-%Y %H:%M:%S" )" >> $LOG_FILE;
for apk in $SYS_APK/*/*.apk; do
   $zipalign -c -v 4 $apk >> $LOG_FILE;
   echo ZipAlign completed on $apk >> $LOG_FILE;
done;
for apk in $CORE_APK/*/*.apk; do
   $zipalign -c -v 4 $apk >> $LOG_FILE;
   echo ZipAlign completed on $apk >> $LOG_FILE;
done;
echo "Automatic ZipAlign finished at $( date +"%m-%d-%Y %H:%M:%S" )" >> $LOG_FILE;
