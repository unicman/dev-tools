##
# Useful aliases that are sourced in any shell e.g bash / fish.
# So, please keep only alias statements in this file.
#
# After changing file, confirm it works by executing command:
#
# bash -n aliases.sh.fish && fish -n aliases.sh.fish
#
# Through VIM:!bash -n % && fish -n %
##

# Maven short-cuts

alias mvn.skipITs="mvn clean install -Djacoco.skip=true -DskipITs"
alias mvn.test-all="mvn clean install -Djacoco.skip=true"
alias mvn.build-only='mvn clean install -Djacoco.skip=true -DskipTests=true'
alias mvn.format='mvn com.spotify.fmt:fmt-maven-plugin:format'
alias mvn.index="mvn install -Dfindbugs.skip=true -Dpmd.skip=true -Dmaven.javadoc.skip=true -Dcheckstyle.skip -DskipTests=true -DskipITs -Dpmd.skip=true -Dspotbugs.skip=true -Djacoco.skip=true"
alias mvn.build-ut-it='mvn -T 1C clean verify -DskipTests=true && mvn -T 1C --offline verify -P surefire-tests-only && mvn -T 1C --offline verify -P failsave-tests-only'



# Docker aliases

alias docker.clean-safe='docker rm $(docker ps -qa); docker rmi -f $(docker images -f "dangling=true" -q);'

# Mac OS laptop short-cuts

alias pmset.list='pmset -g'


alias pmset.set.laptop-working='sudo pmset -a lidwake 1 standby 0 && sudo pmset -b sleep 15 displaysleep 5 powernap 0'
alias pmset.set.docked='sudo pmset -a lidwake 0 displaysleep 300 acwake 1 powernap 1 standby 0'
alias pmset.set.presentation='sudo pmset -a lidwake 0 displaysleep 0 sleep 0 acwake 0 standby 0'

alias cpu-temperature='sudo powermetrics --samplers smc |grep -i "CPU die temperature"'

# Aliases for setting permissions

alias chown.local='sudo chown -R $(whoami) /usr/local/bin /usr/local/lib && chmod u+w /usr/local/bin /usr/local/lib'

