#!/usr/bin/env zsh

_zsh_via_ssh_filesystem() {
    case "$OSTYPE" in
        darwin*)
            mount | grep $(df -P . | cut -d' ' -f1 | tail -n1) | sed -E 's/.*\(|,.*//g'
            ;;
        *)
            stat -f -L -c %T .
            ;;
    esac
}

_zsh_via_ssh_hostname() {
    df -P . | tail -n1 | awk -F'[ :]*' '{print $1}'
}

_zsh_via_ssh_mount_dest() {
    df -P . | tail -n1 | awk -F'[ :]*' '{print $2}'
}

_zsh_via_ssh_mount_point() {
    df -P . | tail -n1 | awk -F'[ :]*' '{print $7}'
}

_zsh_via_ssh_pwd() {
    local dest=$(_zsh_via_ssh_mount_dest)
    local dir=$(_zsh_via_ssh_mount_point)
    local path=$(pwd | awk 'gsub("'$dir'", "", $0)')
    echo $dest$path
}

via-ssh() {
    if [[ -z "$@" ]]; then
        print -r -- >&2 'zsh-via-ssh: command must be specified.'
        return 1
    fi

    local filesystem=$(_zsh_via_ssh_filesystem)
    if [[ "$filesystem" =~ 'osxfuse|sshfs|fuseblk' ]]; then
        local pwd=$(_zsh_via_ssh_pwd)
        local hostname=$(_zsh_via_ssh_hostname)

        ssh -o LogLevel=QUIET -t "$hostname" "
            cd $pwd
            $@
        "
        return 0
    fi

    $@
}
