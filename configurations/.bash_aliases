if [ -v $MY_ALIASES_CONFIGURED ];then
  return 0;
fi

if [ $(echo $OSTYPE | grep 'linux') ];then
  # enable color support of ls and also add handy aliases
  alias ls='ls --color=auto'
  alias grep='grep --color=always'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'

  # some more ls aliases
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'

  alias startvpn='sudo systemctl start openvpn@client.service'
  alias stopvpn='sudo systemctl stop openvpn@client.service'
  alias resetvpn='sudo systemctl stop openvpn@client.service && sudo systemctl start openvpn@client.service'
elif [ $(echo $OSTYPE | grep 'darwin') ];then
  source /usr/local/bin/virtualenvwrapper.sh
  alias ls="ls -G"
  alias ll="ls -alF -G"
  alias l="ls -lG"
fi

set MY_ALIASES_CONFIGURED
