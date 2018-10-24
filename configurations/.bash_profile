export PATH="/usr/local/opt/llvm/bin:/usr/local/sbin:$PATH"
export CPATH="/usr/local/opt/llvm/include:$CPATH"
export LD_LIBRARY_PATH="/usr/local/opt/llvm/lib:$LD_LIBRARY_PATH"
export LIBRARY_PATH="/usr/local/opt/llvm/lib:$LIBRARY_PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
if [ -f $HOME/.bashrc ];then
  source $HOME/.bashrc
fi
