#!/usr/bin/env bash

## Uncomment to disable git info
#POWERLINE_GIT=0

__powerline() {
    # reset color
    COLOR_RESET='\[\033[m\]'
	COLOR_TIME=${COLOR_TIME:-'\[\033[38;2;168;184;232m\]'} # 时间颜色
	COLOR_USR=${COLOR_USR:-'\[\033[38;2;237;123;53m\]'} # 用户名颜色
    COLOR_CWD=${COLOR_CWD:-'\[\033[38;2;144;121;237m\]'} # 命令行颜色
    COLOR_GIT=${COLOR_GIT:-'\[\033[38;2;101;163;240m\]'} # git颜色
    COLOR_SUCCESS=${COLOR_SUCCESS:-'\[\033[38;2;145;196;108m\]'} # 命令执行成功
    COLOR_FAILURE=${COLOR_FAILURE:-'\[\033[38;2;252;67;73m\]'} # 命令执行失败

    # Symbols
    SYMBOL_GIT_BRANCH1=${SYMBOL_GIT_BRANCH1:-[}
	SYMBOL_GIT_BRANCH2=${SYMBOL_GIT_BRANCH2:-]}
    SYMBOL_GIT_MODIFIED=${SYMBOL_GIT_MODIFIED:-[M]}
    SYMBOL_GIT_PUSH=${SYMBOL_GIT_PUSH:-↑}
    SYMBOL_GIT_PULL=${SYMBOL_GIT_PULL:-↓}

    if [[ -z "$PS_SYMBOL" ]]; then
      case "$(uname)" in
          Darwin)   PS_SYMBOL='';;
          Linux)    PS_SYMBOL='$';;
          *)        PS_SYMBOL='%';;
      esac
    fi

    __git_info() { 
        [[ $POWERLINE_GIT = 0 ]] && return # disabled
        hash git 2>/dev/null || return # git not found
        local git_eng="env LANG=C git"   # force git output in English to make our work easier

        # get current branch name
        local ref=$($git_eng symbolic-ref --short HEAD 2>/dev/null)

        if [[ -n "$ref" ]]; then
            # prepend branch symbol
            ref=$SYMBOL_GIT_BRANCH1$ref$SYMBOL_GIT_BRANCH2
        else
            # get tag name or short unique hash
            ref=$($git_eng describe --tags --always 2>/dev/null)
        fi

        [[ -n "$ref" ]] || return  # not a git repo

        local marks

        # scan first two lines of output from `git status`
        while IFS= read -r line; do
            if [[ $line =~ ^## ]]; then # header line
                [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PUSH${BASH_REMATCH[1]}"
                [[ $line =~ behind\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PULL${BASH_REMATCH[1]}"
            else # branch is modified if output contains more lines after the header line
                marks="$SYMBOL_GIT_MODIFIED$marks"
                break
            fi
        done < <($git_eng status --porcelain --branch 2>/dev/null)  # note the space between the two <

        # print the git branch segment without a trailing newline
        printf "\nGit:$ref$marks"
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 
        if [ $? -eq 0 ]; then
            local symbol="$COLOR_SUCCESS $PS_SYMBOL $COLOR_RESET"
        else
            local symbol="$COLOR_FAILURE $PS_SYMBOL $COLOR_RESET"
        fi

		local time="$COLOR_TIME[\A]$COLOR_RESET"
		local usr="$COLOR_USR\u: $COLOR_RESET"

        local cwd="$COLOR_CWD\W$COLOR_RESET"
        # Bash by default expands the content of PS1 unless promptvars is disabled.
        # We must use another layer of reference to prevent expanding any user
        # provided strings, which would cause security issues.
        # POC: https://github.com/njhartwell/pw3nage
        # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
        if shopt -q promptvars; then
            __powerline_git_info="$(__git_info)"
            local git="$COLOR_GIT\${__powerline_git_info}$COLOR_RESET"
        else
            # promptvars is disabled. Avoid creating unnecessary env var.
            local git="$COLOR_GIT$(__git_info)$COLOR_RESET"
        fi

        PS1="$time$usr$cwd$git$symbol"
    }

    PROMPT_COMMAND="ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

__powerline
unset __powerline
