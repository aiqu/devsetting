export GOROOT=$HOME/.local/go
export GOPATH=$HOME/workspace/golang
export PATH=$GOPATH/bin:$HOME/.local/bin:$HOME/bin:$PATH
export TERM="xterm-256color"
export BYOBU_CONFIG_DIR=$HOME/.byobu
export BYOBU_PREFIX=$HOME/.local
export LC_ALL='en_US.utf8'
export LANG='en_US.utf8'
export EDITOR=vim
export TMUX_TMPDIR=$HOME/.tmux
mkdir -p $TMUX_TMPDIR $HOME/.local $GOROOT $GOPATH $HOME/.lib

MY_INCLUDE_DIR=$HOME/.local/include
MY_LIBRARY_DIR=$HOME/.local/lib:$HOME/.local/lib64
MY_PKG_CONFIG_DIR=$HOME/.local/share/pkgconfig:$HOME/.local/lib/pkgconfig:$HOME/.local/lib64/pkgconfig

export CPATH=$MY_INCLUDE_DIR:$CPATH
if [ -z $LD_LIBRARY_PATH ];then
  export LD_LIBRARY_PATH=$MY_LIBRARY_DIR:/usr/local/lib:/usr/lib:/usr/local/lib64:/usr/lib64
else
  export LD_LIBRARY_PATH=$MY_LIBRARY_DIR:/usr/local/lib:/usr/lib:/usr/local/lib64:/usr/lib64:$LD_LIBRARY_PATH
fi
if [ -z $LIBRARY_PATH ];then
  export LIBRARY_PATH=$MY_LIBRARY_DIR
else
  export LIBRARY_PATH=$MY_LIBRARY_DIR:$LIBRARY_PATH
fi
export CMAKE_LIBRARY_PATH=$LD_LIBRARY_PATH:$CMAKE_LIBRARY_PATH
export CMAKE_INCLUDE_PATH=$CPATH:$CMAKE_INCLUDE_PATH
export PKG_CONFIG_PATH=$MY_PKG_CONFIG_DIR:$PKG_CONFIG_PATH

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f $HOME/.local/bin/gcc ];then
  export CC=$HOME/.local/bin/gcc
  export CXX=$HOME/.local/bin/g++
fi

if [ -d $HOME/.local/gradle-4.3 ];then
  export GRADLE_HOME=$HOME/.local/gradle-4.3
fi
if [ -d $HOME/.local/jdk1.8.0_152 ];then
  export JAVA_HOME=$HOME/.local/jdk1.8.0_152
fi

if [ -d $HOME/.local/lib/perl5 ];then
  export PERL5LIB=$HOME/.local/lib/perl5
fi

if [ -d $HOME/c3 ];then
    source $HOME/c3/source.me
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Enable bash completion
if [ $PS1 && -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

if [ ! $(echo $- | grep i) ];then
  return;
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

. $HOME/.promptrc
. $HOME/.git-completion
