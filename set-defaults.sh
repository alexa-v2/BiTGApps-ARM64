#!/sbin/sh
#
##############################################################
# File name       : set-defaults.sh
#
# Requirement     : Magisk
#
# Description     : Setup available dependencies for installation
#
# Build Date      : Friday April 26 17:03:10 IST 2019
#
# GitHub          : TheHitMan7 <krtik.vrma@gmail.com>
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2019 TheHitMan7
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
##############################################################

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
