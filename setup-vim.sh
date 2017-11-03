#!/bin/bash
################################################################################
# File: setup-vim.sh
#
# Date (M/D/Y)         Name            Description
# 11/03/2017           unicman         Created
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
	$GIT_URL=$1
	$DIR_PLUGIN=$2
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
DIR_UM_GIT=~/um-git-2
UNAME_OS=$(uname -o)
UNAME=$(uname)
STEPS=5
STEP=0

if [ "${TMP}" == "" ] ; then
	export TMP="/tmp"
fi

if [ "$UNAME" != "Linux" ] && [ "$UNAME_OS" != "Msys" ] ; then
        echo "This script is only supported on Linux and Git Bash on Windows."
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
echo "**** Step ${STEP}/${STEPS} Creating basic VIM folders"
echo "********************************************************************************"
echo ""

if [ "$UNAME_OS" == "Msys" ] ; then
	DIR_AUTOLOAD=~/vimfiles/autoload
	DIR_BUNDLE=~/vimfiles/bundle
else
	DIR_AUTOLOAD=~/.vim/autoload
	DIR_BUNDLE=~/.vim/bundle
fi

fnExec mkdir -p ${DIR_AUTOLOAD} # Required for automatically loading pathogen
fnExec mkdir -p ${DIR_BUNDLE} # Pathogen needs it to store all other plugins

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Installing pathogen..."
echo "********************************************************************************"
echo ""

fnExec rm -fr ${TMP}/vim-pathogen # Delete earlier pathogen VIM plugin if it's present

fnGitClone https://github.com/tpope/vim-pathogen.git ${TMP}/vim-pathogen # Fetch pathogen VIM package manager

fnExec cp -f ${TMP}/vim-pathogen/autoload/pathogen.vim ${DIR_AUTOLOAD}/ # Copy pathogen for it to auto-load

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Installing plugins..."
echo "********************************************************************************"
echo ""

fnExec cd ${DIR_BUNDLE}
fnGitClone https://github.com/w0rp/ale.git ./ale # Asynchronous Lint Engine
fnGitClone https://github.com/scrooloose/nerdtree.git ./nerdtree # quick navigation
fnGitClone https://github.com/majutsushi/tagbar.git ./tagbar # source code outline
fnGitClone https://github.com/tpope/vim-fugitive.git ./fugitive # Git wrapper
fnGitClone https://github.com/shumphrey/fugitive-gitlab.vim.git ./fugitive-gitlab # Gitlab wrapper

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Configure VIM with usual dev settings..."
echo "********************************************************************************"
echo ""

if [ "$UNAME_OS" == "Msys" ] ; then
	fnExec cmd <<< "mklink _vimrc ${DIR_UM_GIT}/dev-tools/dev.vim" # Create symbolic link to VIM settings
else
	fnExec ln -s ${DIR_UM_GIT}/dev-tools/dev.vim .vimrc # Create symbolic link to VIM settings
fi

