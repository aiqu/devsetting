function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q -g __fish_gwangminlee_functions_defined
        set -g __fish_gwangminlee_functions_defined
        function _is_git_repo
            type -q git
            or return 1
            git status -s >/dev/null ^/dev/null
        end

        function _repo_branch_name
            set -l branch (git symbolic-ref --quiet HEAD ^/dev/null)
            if set -q branch[1]
                echo (string replace -r '^refs/heads/' '' $branch)
            else
                echo (git rev-parse --short HEAD ^/dev/null)
            end
        end

        function _is_repo_modified
            git status --porcelain ^/dev/null | grep -qi -e '^.M\|^.D'
        end
        function _is_repo_staged
            git status --porcelain ^/dev/null | grep -qi -e '^M\|^D'
        end
        function _is_repo_has_untracked
            git status --porcelain ^/dev/null | grep -qi -e '^??'
        end

        function _repo_type
            if _is_git_repo
                echo 'git'
            end
        end
    end

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)

    set -l root_indicator_color "$green"
    if test $__last_command_exit_status != 0
        set root_indicator_color "$red"
    end

    set -l root_indicator_symbol "\$"
    if test "$USER" = 'root'
        set root_indicator_symbol "#"
    end
    set -l root_indicator "$root_indicator_color$root_indicator_symbol$normal"

    set -l cwd $cyan(prompt_pwd)

    set -l repo_type (_repo_type)
    if [ $repo_type ]
        set -l repo_color $green
        set -l repo_status ''
        if _is_repo_modified
          set repo_color $red
          set repo_status $repo_status'❗'
        end
        if _is_repo_staged
          set repo_color $red
          set repo_status $repo_status'➕'
        end
        if _is_repo_has_untracked
          set repo_color $red
          set repo_status $repo_status'❓'
        end
        set -l repo_branch $repo_color(_repo_branch_name)
        set repo_info "$blue ($repo_branch$repo_status$blue)$normal"
    end

    if test $__last_command_exit_status != 0
      set status_msg $red $__last_command_exit_status $normal '🤔'
    end
    echo -n -s $status_msg $USER'@'(prompt_hostname) ' ' $cwd $repo_info $root_indicator ' '
end
