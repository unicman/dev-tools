#!/bin/bash
################################################################################
# File: setup-vim.sh
#
# Date (M/D/Y)         Name            Description
# 11/06/2017           unicman         Created
################################################################################

set -e # Any command failures should abort script

########################################
# Utility functions
########################################

fnExec()
{
    echo ""
    echo "**** $*"
    $*
}

########################################
# Setup logic
########################################
DIR_UM_GIT=~/um-git
UNAME_OS=$(uname -o)
UNAME=$(uname)
STEPS=6
STEP=0

if [ "${TMP}" == "" ] ; then
	export TMP="/tmp"
fi

if [ "$UNAME" != "Linux" ] ; then
        echo "This script is only supported on Linux."
        exit 1
fi

fnExec ln -sf ${DIR_UM_GIT}/dev-tools/screenrc ~/.screenrc

