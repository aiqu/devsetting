source /usr/local/bin/virtualenvwrapper.sh

export PATH=$HOME/.local/bin:$HOME/bin:$PATH
export TERM="xterm-256color"
alias ls="ls -G"
alias ll="ls -alF -G"
alias l="ls -lG"
## PYENV CONFIGURATION ##
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/bin:$PATH
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
. ~/.promptrc

export OPENNI2_REDIST=/usr/local/lib/ni2
export OPENNI2_INCLUDE=/usr/local/include/ni2
