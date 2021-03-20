# Vim bash-completion

This repository contains a bash-completion file for vim.

The following features are curently supported:
- auto completion of remote files (``vim scp://$host//files``)
- basic argument completion

## Requirements

- bash and bash-completion
- vim scp:// completion
  - configure your ssh_config so that you can connect to your hosts by name without any options and ideally without a password prompt everytime
    - using key based authentication with ssh-agent or passwordless keyfiles is preferred
```ssh_config
Host machine
  Hostname 10.0.0.1
  User account
  IdentityFile ~/.ssh/id_ed25519
  PubkeyAuthentication yes
```
  - if the completion should be fast you want to enable control sockets
```ssh_config
Host *
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%C
  ControlPersist 15m
```
  - remove ``:`` from COMP_WORDBREAKS which can be done by adding the following line to your bashrc
    - this is required because ``vim scp://machine//home/user/.bashrc`` does not use the same format as ``{rsync,scp} machine:/home/user/.bashrc`` does but the completion files by bash-completion are re-used
```bash
export COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
```
- clone the repo this repository into some directory ``git clone https://github.com/SuperSandro2000/vim-bash-completion.git ~/.bash_completion.d/vim-bash-completion``
- load the completion file
  - on demand: either symlink (preferred) or copy the vim file into the follwoing directory
    - the directory can be defined by ``$BASH_COMPLETION_USER_DIR/completions`` which defaults to ``$XDG_DATA_HOME/bash-completion/completions`` which on itself defaults to ``~/.local/share/bash-completion/completions``
    - See the question ``Q. Where should I install my own local completions?`` at the [bash-completion faq](https://github.com/scop/bash-completion#faq) for details
  - source the vim file in ``~/.bash_completion``
  - if you do not want to clone the repository you can also copy the function from the vim file into your ``~/.bash_completion``

## Motivation

I was surprised that I couldn't find any bash-completion script for vim.
I also learned a couple of days before the scp:// remote feature in vim which is not that usuable without knowing file paths off the top of your head.
I knew that scp and rsync have fantastic bash-completion for remote files which are very responsive if you use ssh sontrol sockets. See ``man ssh_config`` and search for ControlMaster.
