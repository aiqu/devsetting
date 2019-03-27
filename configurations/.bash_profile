export PATH="/usr/local/sbin:$HOME/Library/Python/3.7/bin:$PATH"
if hash -r jenv;then
  eval "$(jenv init -)"
fi
if [ -f $HOME/.bashrc ];then
  source $HOME/.bashrc
fi
