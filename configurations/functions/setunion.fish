function setunion -S -d "add values of second variable not exist on first variable to first variable"
  if [ (count $argv) -ne 2 ]
    echo "setunion: exact two arguments expected"
    return
  end
  if not set -q $argv[1]
    set -xl $argv[1] $$argv[2]
    return
  end
  for p in $$argv[2]
    if not string match -q $p $$argv[1]
      set $argv[1] $p $$argv[1]
    end
  end
end
