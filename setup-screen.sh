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

fnGitClone()
{
	GIT_URL=$1
	DIR_PLUGIN=$2
	if [ -d ${DIR_PLUGIN} ] ; then
		fnExec cd ${DIR_PLUGIN}
		fnExec git pull
	else
		fnExec git clone ${GIT_URL} ${DIR_PLUGIN}
	fi
}

########################################
# Setup logic
########################################
DIR_UM_GIT=~/um-git
UNAME_OS=$(uname -o)
UNAME=$(uname)
STEPS=2
STEP=0

if [ "${TMP}" == "" ] ; then
	export TMP="/tmp"
fi

if [ "$UNAME_OS" == "Msys" ] ; then
    echo "Screen setup is not applicable on Windows. Skipping."
    exit 0
elif [ "$UNAME" != "Linux" ] ; then
    echo "This script is only supported on Linux."
    exit 1
fi

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Download all setup files from github..."
echo "********************************************************************************"
echo ""

fnExec mkdir -p ${DIR_UM_GIT} # Create folder in user home to fetch all setup files
fnGitClone https://github.com/unicman/dev-tools.git ${DIR_UM_GIT}/dev-tools # Fetch all setup files

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Linking screen utility config file..."
echo "********************************************************************************"
echo ""

fnExec ln -sf ${DIR_UM_GIT}/dev-tools/screenrc ~/.screenrc

