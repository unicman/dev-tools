#!/bin/bash
################################################################################
# File: bash-aliases.sh
#
# Date (M/D/Y)         Name            Description
# 06/29/2020           unicman         Created
################################################################################

BASH_ALIAS_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
export PATH="${BASH_ALIAS_DIR}/shell-scripts:$PATH"

source ${BASH_ALIAS_DIR}/aliases.sh.fish

export CLICOLOR=1 # Ensures ls etc commands show colors

if ansible --version > /dev/null 2>&1 ; then
    source $(dirname $(realpath $BASH_SOURCE))/ansible-aliases.sh
fi

if [ -d ./shell-scripts ] ; then
    export PATH="./shell-scripts:$PATH"
fi

if [ -f ./.bashrc ] ; then
    source ./.bashrc
fi

if [ -f ./aliases.sh.fish ] ; then
    source ./aliases.sh.fish
fi
