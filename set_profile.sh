## Originated from https://github.com/dkim010/settings
## command: . set_profile.sh

if [ -z $1 ]; then
  echo 'insert username'
else
  ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
  PROFILE_PATH_HOME=$HOME/users
  USER_NAME=$1

  ## profile setting
  cp ${ROOT}/func_profile $HOME
  if ! grep -q PROFILE_PATH_HOME $HOME/.bashrc ; then
    echo -e "export PROFILE_PATH_HOME=$PROFILE_PATH_HOME\nif [ -f \$HOME/func_profile ]; then\n  . \$HOME/func_profile\nfi" >> $HOME/.bashrc
  fi

  mkdir -p $HOME/users/$USER_NAME
fi
