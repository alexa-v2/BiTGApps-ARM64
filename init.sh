##############################################################
# File name       : init.sh
#
# Requirement     : Magisk
#
# Description     : Setup environmental variables and helper functions
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

# begin properties
properties() { '
build.string=
do.devicecheck=1
do.cleanup=1
do.cleanuponabort=1
supported.sdk=28
supported.versions=9.0.0
'; } # end properties

# load data from installer
. /tmp/install/installer.sh;

## begin install

start_service;

## end install
