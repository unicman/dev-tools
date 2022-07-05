echo "SUCCESS: Loading Ansible aliases..."

export ANSIBLE_INVENTORY=~/.ansible/inventory/

fnSshAnsibleConfigAutocomplete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(ansible-inventory --graph 2>&1 | grep "|--[^@]" | sed 's/^.*--//g' | sort | uniq)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}

complete -F fnSshAnsibleConfigAutocomplete ssh

