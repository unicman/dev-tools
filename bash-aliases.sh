################################################################################
# File: bash-aliases.sh
#
# Date (M/D/Y)         Name            Description
# 06/29/2020           unicman         Created
################################################################################

function fnDockerCleanAll() {
    #_DOCKER_CONTAINER_LIST=$(docker ps -a -q -f status=exited)
    #if [ "${_DOCKER_CONTAINER_LIST}" != "" ] ; then
    #    echo "Deleting exited containers..."
    #    docker rm -v ${_DOCKER_CONTAINER_LIST}
    #fi

    #_DOCKER_IMAGE_LIST=$(docker images -f "dangling=true" -q)

    #if [ "${_DOCKER_IMAGE_LIST}" != "" ] ; then
    #    echo "Deleting untagged images..."
    #    docker rmi ${_DOCKER_IMAGE_LIST}
    #fi

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

alias tools.docker-clean-all='fnDockerCleanAll'

alias tools.reload-ssh='echo "Removing PKCS cached SSH key..." && ssh-add -e /usr/local/lib/opensc-pkcs11.so && echo "Adding PKCS SSH key..." && ssh-add -s /usr/local/lib/opensc-pkcs11.so'
