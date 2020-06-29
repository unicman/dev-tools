################################################################################
# File: bash-aliases.sh
#
# Date (M/D/Y)         Name            Description
# 06/29/2020           unicman         Created
################################################################################

alias tools.docker-clean-all='echo "Deleting exited containers..." && docker rm -v $(docker ps -a -q -f status=exited) && echo "Deleting untagged images." && docker rmi $(docker images -f "dangling=true" -q) && echo "SUCCESS."'

alias tools.reload-ssh='echo "Removing PKCS cached SSH key..." && ssh-add -e /usr/local/lib/opensc-pkcs11.so && echo "Adding PKCS SSH key..." && ssh-add -s /usr/local/lib/opensc-pkcs11.so'
