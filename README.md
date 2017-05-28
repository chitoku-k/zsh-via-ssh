zsh-via-ssh
===========

Provides a utility command to run through SSH. Some commands work absurdly
slowly when dealing with directories under mount points, however, this command
detects whether the current directory is mounted over SSH and yields execution
to another connection, if possible.

This is useful with `grep`ping files recursively or fetching `git` data from the
large repository, which are much faster to be done through SSH.

If PWD is not located over SSH mount point this command does nothing special;
execute the command just as usual.

Examples:

```console
$ cd /mnt/remote
$ via-ssh grep 'curl_init' 'src/**/*.php'
$ via-ssh git status
```
