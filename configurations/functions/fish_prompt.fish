function fish_prompt
    set -l __last_command_exit_status $status

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)
    set -l branch (git rev-parse --abbrev-ref HEAD ^/dev/null)

    # -- Status code message
    set -l status_msg ''
    if test $__last_command_exit_status != 0
      set status_msg "$red$__last_command_exit_status $normal"
    end
    # -- prompt symbol
    set -l root_indicator "\$"
    if test "$USER" = 'root'
        set root_indicator "#"
    end
    set root_indicator $green$root_indicator
    # -- Git status message
    if string length $branch >/dev/null
      set -l branch_status ''
      if git status --porcelain ^/dev/null | grep -qi -e '^.M\|^.D'
        set branch_status "$branch_status$red!"
      end
      if git status --porcelain ^/dev/null | grep -qi -e '^M\|^D'
        set branch_status "$branch_status$green+"
      end
      if git status --porcelain ^/dev/null | grep -qi -e '^??'
        set branch_status "$branch_status$red?"
      end
      if [ -n $branch_status ]
        set branch "$red$branch $branch_status"
      else
        set branch "$green$branch"
      end
      set branch "$blue($branch$blue)$normal"
    end

    set -l cwd $cyan(prompt_pwd)$normal
    set -l host (prompt_hostname)
    echo -n -e "$status_msg$USER@$host $cwd $branch$root_indicator $normal"
end
