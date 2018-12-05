setdefault LOCAL_DIR ~/.local
setdefault TERM screen-256color
set -e TMOUT
set -x GOROOT {$LOCAL_DIR}/go
set -x GOPATH ~/workspace/golang
set -x BYOBU_CONFIG_DIR ~/.byobu
set -x BYOBU_PREFIX $LOCAL_DIR
set -x ACLOCAL_PATH {$LOCAL_DIR}/share/aclocal
set -x EDITOR vim
set -x TMUX_TMPDIR ~/.tmux
mkdir -p $TMUX_TMPDIR $LOCAL_DIR $GOROOT $GOPATH ~/.lib
if string match -qi Darwin (uname)
  set -x PATH /usr/local/sbin $PATH
else
  set -x LC_ALL en_US.utf8
  set -x LANG en_US.utf8
end

set -l MY_INCLUDE_DIR {$LOCAL_DIR}/{include,include/python3.6m}
set -l MY_LIBRARY_DIR {$LOCAL_DIR}/{lib,lib64}
set -l SYSTEM_LIBRARY_DIR /usr/local/{lib,lib64} /usr/{lib,lib64}
set -l MY_CMAKE_PREFIX_PATH {$LOCAL_DIR} {$LOCAL_DIR}/{share,lib64}
set -l MY_PKG_CONFIG_DIR {$LOCAL_DIR,usr}/{share,lib,lib64}/pkgconfig
set -l MY_MANPATH {$LOCAL_DIR,/usr/local,/usr}/share/man
set -l MY_PATH {$GOPATH,$LOCAL_DIR,~}/bin
if type -q yarn
  set MY_PATH (yarn global bin) $MY_PATH
end

setunion PATH MY_PATH
setunion2 CPATH MY_INCLUDE_DIR
setunion2 LD_LIBRARY_PATH MY_LIBRARY_DIR
setunion2 LIBRARY_PATH MY_LIBRARY_DIR
setunion2 CMAKE_PREFIX_PATH MY_CMAKE_PREFIX_PATH
setunion2 PKG_CONFIG_PATH MY_PKG_CONFIG_DIR
setunion2 MANPATH MY_MANPATH

# colored GCC warnings and errors
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# colored grep
set -x GREP_COLORS "ms=01;38;5;202:mc=01;31:sl=:cx=:fn=01;38;5;132:ln=32:bn=32:se=00;38;5;242"

if [ -f {$LOCAL_DIR}/bin/gcc ]
  set -x CC {$LOCAL_DIR}/bin/gcc
  set -x CXX {$LOCAL_DIR}/bin/g++
end

if [ -d {$LOCAL_DIR}/gradle-4.3 ]
  set -x GRADLE_HOME {$LOCAL_DIR}/gradle-4.3
end
if [ -d {$LOCAL_DIR}/jdk1.8.0_152 ]
  set -x JAVA_HOME {$LOCAL_DIR}/jdk1.8.0_152
end

if [ -d {$LOCAL_DIR}/lib/perl5 ]
  set -x PERL5LIB {$LOCAL_DIR}/lib/perl5
end

if not status --is-interactive
  exit 0
end

set AUTOJUMP_SETTING ~/.autojump/share/autojump/autojump.fish
[ -s $AUTOJUMP_SETTING ]; and source $AUTOJUMP_SETTING

# don't put duplicate lines or lines starting with space in the history.
set -x HISTCONTROL ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
set -x HISTSIZE 500
set -x HISTFILESIZE 0
