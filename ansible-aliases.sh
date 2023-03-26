export ANSIBLE_INVENTORY=~/.ansible/inventory/

fnSshAnsibleConfigAutocomplete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    #opts=$(ansible-inventory --graph 2>&1 | grep "|--[^@]" | sed 's/^.*--//g' | sort | uniq)
    chh=$(find /tmp/bash-ansible-cache -mtime +1 -print 2> /dev/null || true)
    if [ -f /tmp/bash-ansible-cache ] && [ "${chh}" != "/tmp/bash-ansible-cache" ] ; then
        opts=$(cat /tmp/bash-ansible-cache)
    else
        opts=$(ansible-inventory --list 2> /dev/null | jq -r '.[] | .hosts | .[]' 2> /dev/null)
        echo "${opts}" > /tmp/bash-ansible-cache
    fi

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}

complete -F fnSshAnsibleConfigAutocomplete ssh

echo "SUCCESS: Ansible aliases loaded."
