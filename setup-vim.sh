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

fnExecSudo()
{
    echo ""
    echo "**** $*"

    if [ "$UNAME_OS" == "Msys" ] ; then
        $*
    else
        sudo $*
    fi
}

fnGitClone()
{
    GIT_URL=$1
    DIR_PLUGIN=$2
    if [ -d ${DIR_PLUGIN} ] ; then
        fnExec cd ${DIR_PLUGIN}
        fnExec git pull
    else
        fnExec git clone -c "user.name=${UM_USER}" -c "user.email=${UM_EMAIL}" ${GIT_URL} ${DIR_PLUGIN}
    fi
}

fnSoftLink()
{
    if [ "$UNAME_OS" == "Msys" ] ; then
        cWinLinkPath=$(cygpath -w $2)
        cWinFilePath=$(cygpath -w $1)
        cWinDir=$3

        # Ensure that earlier sym link is deleted without deleting original content
        if [ -d ${cWinLinkPath} ] ; then
            fnExec cmd <<< "rmdir ${cWinLinkPath}" 
        elif [ -f ${cWinLinkPath} ] ; then
            fnExec rm ${cWinLinkPath}
        fi

        if [ "${cWinDir}" == "-folder" ] ; then
            fnExec cmd <<< "mklink /d ${cWinLinkPath} ${cWinFilePath}" # Create symbolic link to folder
        else
            fnExec cmd <<< "mklink ${cWinLinkPath} ${cWinFilePath}" # Create symbolic link to file
        fi
    else
        fnExec ln -sf $1 $2 # Create symbolic link to VIM settings
    fi
}

########################################
# Setup logic
########################################
DIR_UM_GIT=~/um-git
UNAME=$(uname)
STEPS=9
STEP=0

if [ "${UM_USER}" == "" ] ; then
    export UM_USER=unicman
    export UM_EMAIL=unicman@gmail.com
fi

if [ "$UNAME" != "Darwin" ] ; then
    UNAME_OS=$(uname -o)
else
    UNAME_OS=""
fi

if [ "${TMP}" == "" ] ; then
    export TMP="/tmp"
fi

if [ "$UNAME" != "Darwin" ] && [ "$UNAME" != "Linux" ] && [ "$UNAME_OS" != "Msys" ] ; then
    echo "This script is only supported on Linux, Mac and Git Bash on Windows."
    exit 1
fi

fnExec git --version

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
    fnSoftLink ~/.vim ~/vimfiles -folder # Create symbolic link to VIM settings
fi

DIR_AUTOLOAD=~/.vim/autoload
DIR_BUNDLE=~/.vim/bundle
DIR_COMPILER=~/.vim/compiler

fnExec mkdir -p ${DIR_AUTOLOAD} # Required for automatically loading pathogen
fnExec mkdir -p ${DIR_BUNDLE} # Pathogen needs it to store all other plugins
fnExec mkdir -p ${DIR_COMPILER} # Pathogen needs it to store all other plugins

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Configuring VIM compilers..."
echo "********************************************************************************"
echo ""

for cFilePath in ${DIR_UM_GIT}/dev-tools/compiler/*.vim 
do
    cFileName=$(basename $cFilePath)

    fnSoftLink ${cFilePath} ${DIR_COMPILER}/${cFileName} # Create symbolic link to VIM settings
done

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Installing pathogen..."
echo "********************************************************************************"
echo ""

fnGitClone https://github.com/tpope/vim-pathogen.git ${TMP}/vim-pathogen # Fetch pathogen VIM package manager

fnExec cp -f ${TMP}/vim-pathogen/autoload/pathogen.vim ${DIR_AUTOLOAD}/ # Copy pathogen for it to auto-load

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Removing unused plugins..."
echo "********************************************************************************"
echo ""

echo ""
echo "**** Removing nerdtree in factor of CtrlP that's much easy to use..."

#fnGitClone https://github.com/vim-scripts/gitignore.git ${DIR_BUNDLE}/gitignore # useful to filter out files in gitignore in nerdtree
fnExec rm -fr ${DIR_BUNDLE}/gitignore

#fnGitClone https://github.com/scrooloose/nerdtree.git ${DIR_BUNDLE}/nerdtree # quick navigation
fnExec rm -fr ${DIR_BUNDLE}/nerdtree 

#fnGitClone https://github.com/Xuyuanp/nerdtree-git-plugin ${DIR_BUNDLE}/nerdtree-git-plugin # Git support for quick navigation (disabled)
fnExec rm -fr ${DIR_BUNDLE}/nerdtree-git-plugin

echo ""
echo "**** Removing bad plugin asyncrun ... vim dispatch is better..."

#fnGitClone https://github.com/skywind3000/asyncrun.vim.git ${DIR_BUNDLE}/asyncrun # Allows make and other commands to be run without blocking VIM
fnExec rm -fr ${DIR_BUNDLE}/asyncrun

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Installing plugins..."
echo "********************************************************************************"
echo ""

fnGitClone https://github.com/w0rp/ale.git ${DIR_BUNDLE}/ale # Asynchronous Lint Engine
fnGitClone https://github.com/majutsushi/tagbar.git ${DIR_BUNDLE}/tagbar # source code outline
fnGitClone https://github.com/tpope/vim-fugitive.git ${DIR_BUNDLE}/vim-fugitive # Git wrapper
fnGitClone https://github.com/shumphrey/fugitive-gitlab.vim.git ${DIR_BUNDLE}/fugitive-gitlab.vim # Gitlab wrapper
fnGitClone https://github.com/artur-shaik/vim-javacomplete2.git ${DIR_BUNDLE}/javacomplete2 # Auto-complete for Java
fnGitClone https://github.com/aklt/plantuml-syntax.git ${DIR_BUNDLE}/plantuml-syntax # plantuml syntax support
fnGitClone https://github.com/davidhalter/jedi-vim.git ${DIR_BUNDLE}/jedi-vim # Auto-complete for python (depends on jedi)
fnGitClone https://github.com/ctrlpvim/ctrlp.vim.git ${DIR_BUNDLE}/ctrlp # Fuzzy file search
fnGitClone https://github.com/vim-airline/vim-airline.git ${DIR_BUNDLE}/vim-airline # Nice status line and tab line
fnGitClone https://github.com/vim-airline/vim-airline-themes.git ${DIR_BUNDLE}/vim-airline-themes # Nice themes for status line and tab lines
fnGitClone https://github.com/tpope/vim-dispatch.git ${DIR_BUNDLE}/vim-dispatch # Asynchronous make or grep commands in Vim 8

echo ""
echo "**** Deleting intermediate files of javacomplete2 plugin to allow re-generation after next VIM run..."
rm -fr ${DIR_BUNDLE}/javacomplete2/libs/javavi/target

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Install Python modules..."
echo "********************************************************************************"
echo ""

echo ""
echo "**** Installing jedi required for jedi-vim..."

fnExecSudo pip install jedi flake8

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Install Universal ctags..."
echo "********************************************************************************"
echo ""

if [ "$UNAME" == "Darwin" ] || [ "$UNAME_OS" == "Msys" ] ; then
    echo "Need to write code for Mac and Windows installation of universal ctags."
else
    fnGitClone https://github.com/universal-ctags/ctags.git ${DIR_UM_GIT}/universal-ctags # Fetch latest source
    fnExec cd ${DIR_UM_GIT}/universal-ctags
    fnExec ./autogen.sh
    fnExec ./configure --prefix=${DIR_UM_GIT}/universal-ctags
    fnExec make
    fnExec make install

    fnExec ctags --version
fi

STEP=`expr ${STEP} + 1`
echo ""
echo "********************************************************************************"
echo "**** Step ${STEP}/${STEPS} Configure VIM with usual dev settings..."
echo "********************************************************************************"
echo ""

fnExec cd ~ # Switch back to user home folder

fnSoftLink ${DIR_UM_GIT}/dev-tools/dev.vim _vimrc # Create symbolic link to VIM settings
fnSoftLink ${DIR_UM_GIT}/dev-tools/dev.vim .vimrc # Create symbolic link to VIM settings
