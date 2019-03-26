alias grep='\grep --color=always'
alias fgrep='\fgrep --color=auto'
alias egrep='\egrep --color=auto'

if [ $(echo $OSTYPE | grep 'linux') ];then
  # enable color support of ls and also add handy aliases
  alias ls='\ls --color=auto'
  alias ll='\ls -alF --color=auto'
  alias la='\ls -A --color=auto'
  alias l='\ls -CF --color=auto'
  if [ -r $HOME/.ssh/config ];then
    alias ssh="\ssh -F $HOME/.ssh/config"
  fi

  alias startvpn='sudo systemctl start openvpn@client.service'
  alias stopvpn='sudo systemctl stop openvpn@client.service'
  alias resetvpn='sudo systemctl stop openvpn@client.service && sudo systemctl start openvpn@client.service'
elif [ $(echo $OSTYPE | grep 'darwin') ];then
  alias ls='\ls -G'
  alias ll='\ls -alFG'
  alias la='\ls -AG'
  alias l='\ls -CFG'
fi
