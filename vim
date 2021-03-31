# bash-completion for the vim command
# Author: Sandro Jäckel <sandro.jaeckel@gmail.com>
# License: MIT

_completion_loader rsync ssh

# shellcheck disable=SC2207

_vim() {
  # shellcheck disable=SC2034
  local cur prev words cword split
  _init_completion -s -n : || return

  $split && return

  case $cur in
    "scp://"*"/" | "scp://"*"/"*)
      # build scp like remote string
      sav=$cur
      cur=${cur#'scp://'}
      cur=${cur/\//:/}

      _xfunc ssh _scp_remote_files

      # rebuild vim string
      host=${sav#'scp://'}
      host=${host%%/*}

      local i=${#COMPREPLY[*]}
      while ((i-- > 0)); do
        COMPREPLY[i]=$(compgen -W "scp://$host${COMPREPLY[i]}" -- "$sav")
      done
      ;;
    "scp://"*)
      # -a  Use aliases from ssh config files
      # -p  Use 'scp://' PREFIX
      _known_hosts_real -a -p 'scp://' -- "${cur#'scp://'}"

      local i=${#COMPREPLY[*]}
      while ((i-- > 0)); do
        COMPREPLY[i]=$(compgen -W "${COMPREPLY[i]}//" -- "$cur")
      done
      ;;
    -V)
      COMPREPLY=($(compgen -W '-V{1..10}' -- "$cur"))
      # compopt +o nospace
      ;;
    -*)
      # output of --help, sorted
      COMPREPLY=($(compgen -W '-t -q -- -v -e -E -s -d -y -R -Z -m -M -b -l -C -N -V -D 
                   -n -r -L -A -H -T --not-a-term --ttyfail -u --noplugin -p -o -O + --cmd
                   -S -s -w -W -x --startuptime -i --clean -h --help --version' -- "$cur"))
      # man page, might not be in your vim compilation because they may require features like gui
      COMPREPLY+=($(compgen -W '+/ -c -f --nofork -F -g -nb -U -X --echo-wid --literal --remote
                    --remote-expr --remote-send --remote-silent --remote-wait --remote-wait-silent
                    --serverlist --servername --socketid' -- "$cur"))
      ;;
    *)
      [[ $cur != scp: ]] && COMPREPLY=($(compgen -W 'scp://' -- "$cur"))
      _tilde "$cur" || return
      compopt -o filenames
      COMPREPLY+=($(compgen -d -- "$cur"))
      ;;
  esac
} &&
  complete -F _vim -o nospace vim
