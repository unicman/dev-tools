#!/bin/bash
################################################################################
# File: bash-aliases.sh
#
# Date (M/D/Y)         Name            Description
# 06/29/2020           unicman         Created
################################################################################

function __fnDockerCleanAll() {
    docker system prune
    docker images prune

    _DOCKER_VOLUME_LIST=$(docker volume ls -q)

    if [ "${_DOCKER_VOLUME_LIST}" != "" ] ; then
        docker volume ls
        read -p "Delete all volumes too (y/n)?" _DEL_VOL

        if [[ "${_DEL_VOL}" =~ ^[yY].*$ ]] ; then
            docker volume rm ${_DOCKER_VOLUME_LIST}
        fi
    fi

    docker system df
}

function __fnDockerCleanImages() {
    docker images | while read line ; do
        _D_IMAGE=$(echo "${line}" | awk '{ print $1 }')
        _D_TAG=$(echo "${line}" | awk '{ print $2 }')
        _D_ID=$(echo "${line}" | awk '{ print $3 }')
        read -p "Delete ${_D_IMAGE}:${_D_TAG} (y/n)?" _DEL_D < /dev/tty

        if [[ "${_DEL_D}" =~ ^[yY].*$ ]] ; then
            docker rmi ${_D_ID}
        fi
    done
}

alias docker.clean-all='__fnDockerCleanAll'

alias docker.clean-safe='docker rm $(docker ps -qa); docker rmi -f $(docker images -f "dangling=true" -q);'

alias docker.clean-images='__fnDockerCleanImages'

alias ssh.reload-key='echo "Removing PKCS cached SSH key..." && ssh-add -e /usr/local/lib/opensc-pkcs11.so && echo "Adding PKCS SSH key..." && ssh-add -s /usr/local/lib/opensc-pkcs11.so'

function __fnTerraformFilterGraph() {
    if [ "$1" == "" ] || [ "$2" == "" ] ; then
        echo "Usage: <alias> <path_of_terraform_graph_output> <regex>"
        return
    fi
    cat <<EOF | dot -Tsvg > $1.svg
digraph {
	compound = "true"
	newrank = "true"
	graph [splines=ortho, nodesep=1]
	subgraph "root" {
$(grep "$2" $1)
    }
}
EOF
    echo "$1.svg contains filtered graph."
}

alias terraform.filter-graph='__fnTerraformFilterGraph'



# Mac OS laptop short-cuts

alias pmset.list='pmset -g'


alias pmset.set.laptop-working='sudo pmset -a lidwake 1 standby 0 && sudo pmset -b sleep 15 displaysleep 5 powernap 0'
alias pmset.set.docked='sudo pmset -a lidwake 0 displaysleep 300 acwake 1 powernap 1 standby 0'
alias pmset.set.presentation='sudo pmset -a lidwake 0 displaysleep 0 sleep 0 acwake 0 standby 0'

alias cpu-temperature='sudo powermetrics --samplers smc |grep -i "CPU die temperature"'

if ansible --version > /dev/null 2>&1 ; then
    source $(dirname $(realpath $BASH_SOURCE))/ansible-aliases.sh
fi

# Aliases for setting permissions

alias chown.local='sudo chown -R $(whoami) /usr/local/bin /usr/local/lib && chmod u+w /usr/local/bin /usr/local/lib'

# Git short-cuts

function fnGitRenameBranch() {
    TO_B=$2
    FROM_B=$(git branch --show-current)

    git branch -m ${TO_B} && git push origin -u ${TO_B} && git push origin --delete ${FROM_B}
}

alias git.branch.rename='fnGitRenameBranch'

function fnGitResetBranch() {
    TO_C=$1
    FROM_B=$(git branch --show-current)

    git reset --hard ${TO_C} && git push -f origin ${FROM_B}
}

alias git.branch.reset='fnGitRenameBranch'

