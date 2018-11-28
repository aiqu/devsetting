function setdefault -S -d "if given variable not defined, set it with given default value"
  if [ (count $argv) -ne 2 ]
    echo "require variable name and defualt value"
    return
  end
  set -q $argv[1]; or set -x $argv[1] $argv[2]
end
