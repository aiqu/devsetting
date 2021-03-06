LOCAL_DIR=${LOCAL_DIR:-"$HOME/.local"}
unset TMOUT
export GOROOT=${LOCAL_DIR}/go
export GOPATH=$HOME/workspace/golang
export ACLOCAL_PATH=${LOCAL_DIR}/share/aclocal
if [ ! $(echo $OSTYPE | grep 'darwin') ]; then
  export LC_ALL='en_US.utf8'
  export LANG='en_US.utf8'
fi
export EDITOR=vim
MY_INCLUDE_DIR="${LOCAL_DIR}/include"
if [ -r ${LOCAL_DIR}/include ];then
  for pydir in $(find ${LOCAL_DIR}/include -type d -name 'python*');do
    MY_INCLUDE_DIR=$pydir:$MY_INCLUDE_DIR
  done
  unset pydir
fi
MY_LIBRARY_DIR=${LOCAL_DIR}/lib:${LOCAL_DIR}/lib64
SYSTEM_LIBRARY_DIR="/usr/local/lib:/usr/local/lib64:/usr/lib:/usr/lib64"
MY_PKG_CONFIG_DIR=${LOCAL_DIR}/share/pkgconfig:${LOCAL_DIR}/lib/pkgconfig:${LOCAL_DIR}/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig
MY_MANPATH=$HOME/.local/share/man:/usr/local/share/man:/usr/share/man
if hash yarn 2>/dev/null;then
  YARN_BIN=$(yarn global bin)
fi
MY_PATH=$GOPATH/bin:${LOCAL_DIR}/bin:$HOME/bin${YARN_BIN:+":$YARN_BIN"}
MY_CMAKE_PREFIX_PATH=${LOCAL_DIR}:${LOCAL_DIR}/share:${LOCAL_DIR}/lib64

[[ ! $PATH == *"$MY_PATH"* ]] && \
  export PATH=${MY_PATH}${PATH:+":$PATH"}
[[ ! $CPATH == *"$MY_INCLUDE_DIR"* ]] && \
  export CPATH=${MY_INCLUDE_DIR}${CPATH:+":$CPATH"}
[[ ! $LD_LIBRARY_PATH == *"$MY_LIBRARY_DIR"* ]] && \
  export LD_LIBRARY_PATH=${MY_LIBRARY_DIR}:${SYSTEM_LIBRARY_DIR}${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}
[[ ! $LIBRARY_PATH == *"$MY_LIBRARY_DIR"* ]] && \
  export LIBRARY_PATH=${MY_LIBRARY_DIR}${LIBRARY_PATH:+":$LIBRARY_PATH"}
[[ ! $CMAKE_PREFIX_PATH == *"${MY_CMAKE_PREFIX_PATH}"* ]] && \
  export CMAKE_PREFIX_PATH=${MY_CMAKE_PREFIX_PATH}${CMAKE_PREFIX_PATH:+":$CMAKE_PREFIX_PATH"}
[[ ! $PKG_CONFIG_PATH == *"$MY_PKG_CONFIG_DIR"* ]] && \
  export PKG_CONFIG_PATH=${MY_PKG_CONFIG_DIR}${PKG_CONFIG_PATH:+":$PKG_CONFIG_PATH"}
[[ ! $MANPATH == *"$MY_MANPATH"* ]] && \
  export MANPATH=${MY_MANPATH}${MANPATH:+":$MANPATH"}

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# colored grep
export GREP_COLORS="ms=01;38;5;202:mc=01;31:sl=:cx=:fn=01;38;5;132:ln=32:bn=32:se=00;38;5;242"

if [ -f ${LOCAL_DIR}/bin/gcc ];then
  export CC=${LOCAL_DIR}/bin/gcc
  export CXX=${LOCAL_DIR}/bin/g++
fi

if [ -d ${LOCAL_DIR}/gradle-4.3 ];then
  export GRADLE_HOME=${LOCAL_DIR}/gradle-4.3
fi
if [ -d ${LOCAL_DIR}/jdk1.8.0_152 ];then
  export JAVA_HOME=${LOCAL_DIR}/jdk1.8.0_152
fi

if [ -d ${LOCAL_DIR}/lib/perl5 ];then
  export PERL5LIB=${LOCAL_DIR}/lib/perl5
fi

# Alias definitions.
if [ -r ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# DO NOT PROCEED FURTHER IF NOT RUNNING INTERACTIVELY
case $- in
  *i*) ;;
    *) return ;;
esac

# START OF INTERACTIVE SHELL CONFIGURATION

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export TERM=${TERM:-"screen-256color"}
export BYOBU_CONFIG_DIR=$HOME/.byobu
[ -x ${LOCAL_DIR}/bin/byobu ] && export BYOBU_PREFIX=${LOCAL_DIR}
export BYOBU_PYTHON='/usr/bin/env python'
export TMUX_TMPDIR=$HOME/.tmux
mkdir -p $TMUX_TMPDIR ${LOCAL_DIR} $GOROOT $GOPATH $HOME/.lib

export PROMPT_DIRTRIM="3"

# Enable bash completion
if [[ $PS1 && -f ${LOCAL_DIR}/share/bash-completion/bash_completion ]]; then
  . ${LOCAL_DIR}/share/bash-completion/bash_completion
fi

# Enable autojump
if [[ -s /usr/share/autojump/autojump.sh ]]; then
  source /usr/share/autojump/autojump.sh
elif [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]]; then
  source $HOME/.autojump/etc/profile.d/autojump.sh
fi

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500
HISTFILESIZE=0

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

if [ -r $HOME/.promptrc ];then
  . $HOME/.promptrc
fi
if [ -r $HOME/.git-completion ];then
  . $HOME/.git-completion
fi

if [ -r $HOME/.ssh/config ];then
  export GIT_SSH_COMMAND="ssh -F $HOME/.ssh/config"
fi

for i in $(find $HOME/.profile.d -type f,l 2>/dev/null) ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then
            . "$i"
        else
            . "$i" >/dev/null 2>&1
        fi
    fi
done
unset i
