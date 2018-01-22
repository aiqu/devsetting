LOCAL_DIR=$HOME/.local
export GOROOT=${LOCAL_DIR}/go
export GOPATH=$HOME/workspace/golang
export TERM="xterm-256color"
export BYOBU_CONFIG_DIR=$HOME/.byobu
export BYOBU_PREFIX=${LOCAL_DIR}
export LC_ALL='en_US.utf8'
export LANG='en_US.utf8'
export EDITOR=vim
export TMUX_TMPDIR=$HOME/.tmux
mkdir -p $TMUX_TMPDIR ${LOCAL_DIR} $GOROOT $GOPATH $HOME/.lib

MY_INCLUDE_DIR=${LOCAL_DIR}/include
MY_LIBRARY_DIR=${LOCAL_DIR}/lib:${LOCAL_DIR}/lib64
SYSTEM_LIBRARY_DIR="/usr/local/lib:/usr/local/lib64:/usr/lib:/usr/lib64"
MY_PKG_CONFIG_DIR=${LOCAL_DIR}/share/pkgconfig:${LOCAL_DIR}/lib/pkgconfig:${LOCAL_DIR}/lib64/pkgconfig
MY_MANPATH=$HOME/.local/share/man
MY_PATH=$GOPATH/bin:${LOCAL_DIR}/bin:$HOME/bin

[[ ! $PATH == *"$MY_PATH"* ]] && \
  export PATH=${MY_PATH}${PATH:+":$PATH"}
[[ ! $CPATH == *"$MY_INCLUDE_DIR"* ]] && \
  export CPATH=${MY_INCLUDE_DIR}${CPATH:+":$CPATH"}
[[ ! $LD_LIBRARY_PATH == *"$MY_LIBRARY_DIR"* ]] && \
  export LD_LIBRARY_PATH=${MY_LIBRARY_DIR}:${SYSTEM_LIBRARY_DIR}${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}
[[ ! $LIBRARY_PATH == *"$MY_LIBRARY_DIR"* ]] && \
  export LIBRARY_PATH=${MY_LIBRARY_DIR}${LIBRARY_PATH:+":$LIBRARY_PATH"}
[[ ! $CMAKE_LIBRARY_PATH == *"$LD_LIBRARY_PATH"* ]] && \
  export CMAKE_LIBRARY_PATH=${LD_LIBRARY_PATH}${CMAKE_LIBRARY_PATH:+":$CMAKE_LIBRARY_PATH"}
[[ ! $CMAKE_INCLUDE_PATH == *"$CPATH"* ]] && \
  export CMAKE_INCLUDE_PATH=${CPATH}${CMAKE_INCLUDE_PATH:+":$CMAKE_INCLUDE_PATH"}
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

if [ -d $HOME/c3 ];then
    source $HOME/c3/source.me
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [ ! $(echo $- | grep i) ];then
  return;
fi

export PROMPT_DIRTRIM="3"

# Enable bash completion
if [[ $PS1 && -f ${LOCAL_DIR}/share/bash-completion/bash_completion ]]; then
  . ${LOCAL_DIR}/share/bash-completion/bash_completion
fi

[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

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

. $HOME/.promptrc
. $HOME/.git-completion
