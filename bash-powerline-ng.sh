#!/usr/bin/env bash
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

__powerline() {

    # Unicode symbols
    readonly PS_SYMBOL_DARWIN=''
    readonly PS_SYMBOL_LINUX='\$'
    readonly PS_SYMBOL_OTHER='%'
    readonly GIT_BRANCH_CHANGED_SYMBOL='+'
    readonly GIT_NEED_PUSH_SYMBOL='⇡'
    readonly GIT_NEED_PULL_SYMBOL='⇣'

    # Solarized colorscheme
    readonly FG_BASE03="\[$(tput setaf 8)\]"
    readonly FG_BASE02="\[$(tput setaf 0)\]"
    readonly FG_BASE01="\[$(tput setaf 10)\]"
    readonly FG_BASE00="\[$(tput setaf 11)\]"
    readonly FG_BASE0="\[$(tput setaf 12)\]"
    readonly FG_BASE1="\[$(tput setaf 14)\]"
    readonly FG_BASE2="\[$(tput setaf 7)\]"
    readonly FG_BASE3="\[$(tput setaf 15)\]"

    readonly BG_BASE03="\[$(tput setab 8)\]"
    readonly BG_BASE02="\[$(tput setab 0)\]"
    readonly BG_BASE01="\[$(tput setab 10)\]"
    readonly BG_BASE00="\[$(tput setab 11)\]"
    readonly BG_BASE0="\[$(tput setab 12)\]"
    readonly BG_BASE1="\[$(tput setab 14)\]"
    readonly BG_BASE2="\[$(tput setab 7)\]"
    readonly BG_BASE3="\[$(tput setab 15)\]"

    readonly FG_YELLOW="\[$(tput setaf 3)\]"
    readonly FG_ORANGE="\[$(tput setaf 9)\]"
    readonly FG_RED="\[$(tput setaf 1)\]"
    readonly FG_MAGENTA="\[$(tput setaf 5)\]"
    readonly FG_VIOLET="\[$(tput setaf 13)\]"
    readonly FG_BLUE="\[$(tput setaf 4)\]"
    readonly FG_CYAN="\[$(tput setaf 6)\]"
    readonly FG_GREEN="\[$(tput setaf 2)\]"

    readonly BG_YELLOW="\[$(tput setab 3)\]"
    readonly BG_ORANGE="\[$(tput setab 9)\]"
    readonly BG_RED="\[$(tput setab 1)\]"
    readonly BG_MAGENTA="\[$(tput setab 5)\]"
    readonly BG_VIOLET="\[$(tput setab 13)\]"
    readonly BG_BLUE="\[$(tput setab 4)\]"
    readonly BG_CYAN="\[$(tput setab 6)\]"
    readonly BG_GREEN="\[$(tput setab 2)\]"

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"
    readonly BLINK="\[$(tput blink)\]"

    readonly FG_VENV="\[\e[38;5;0m\]"
    readonly BG_VENV="\[\e[48;5;7m\]"
    readonly FG_VENV_E="\[\e[38;5;7m\]"

    readonly FG_COLOR1="\[\e[38;5;250m\]"
    readonly BG_COLOR1="\[\e[48;5;240m\]"
    readonly FG_COLOR2="\[\e[38;5;240m\]"
    readonly BG_COLOR2="\[\e[48;5;238m\]"
    readonly FG_COLOR3="\[\e[38;5;250m\]"
    readonly BG_COLOR3="\[\e[48;5;238m\]"
    readonly FG_COLOR4="\[\e[38;5;238m\]"
    readonly BG_COLOR4="\[\e[48;5;31m\]"
    readonly FG_COLOR5="\[\e[38;5;15m\]"
    readonly BG_COLOR5="\[\e[48;5;31m\]"
    readonly FG_COLOR6="\[\e[38;5;31m\]"
    readonly BG_COLOR6="\[\e[48;5;237m\]"
    readonly FG_COLOR7="\[\e[38;5;250m\]"
    readonly BG_COLOR7="\[\e[48;5;237m\]"
    readonly FG_COLOR8="\[\e[38;5;237m\]"
    readonly BG_COLOR8="\[\e[48;5;161m\]"
    readonly FG_COLOR9="\[\e[38;5;161m\]"
    readonly BG_COLOR9="\[\e[48;5;161m\]"

    # what OS?
    case "$(uname)" in
        Darwin)
            readonly PS_SYMBOL=$PS_SYMBOL_DARWIN
            ;;
        Linux)
            readonly PS_SYMBOL=$PS_SYMBOL_LINUX
            ;;
        *)
            readonly PS_SYMBOL=$PS_SYMBOL_OTHER
    esac

    # what Server?
    case "$(hostname)" in
    	zbuild)
    		readonly BG_HOSTNAME="$BG_GREEN"
    		readonly FG_HOSTNAME="$FG_GREEN"
    		;;
    	zeus)
    		readonly BG_HOSTNAME="$BG_RED"
    		readonly FG_HOSTNAME="$FG_RED"
    		;;
    	*)
    		readonly BG_HOSTNAME="$BG_COLOR3"
    		readonly FG_HOSTNAME="$FG_COLOR4"
    		;;
    esac

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    __git_info() {
        if [ -n "$TERM_GIT_STATUS" ]; then
            printf "${BG_BLUE}$RESET$BG_BLUE $TERM_GIT_STATUS $RESET$FG_BLUE"
            return
        fi

        [ -x "$(which git)" ] || return    # git not found
        # [ -d .git ] || return              # no .git directory
        [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ] || return

        # get current branch name or short SHA1 hash for detached head
        local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        local marks

        # how many commits local branch is ahead/behind of remote?
        local stat="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead \d\+' | grep -o '\d\+')"
        local behindN="$(echo $stat | grep -o 'behind \d\+' | grep -o '\d\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # print the git branch segment without a trailing newline
    	# branch is modified?
    	if [ -n "$(git status --porcelain)" ]; then
    		printf "${BG_COLOR8}$RESET$BG_COLOR8 $branch$marks $FG_COLOR9"
    	else
    		printf "${BG_BLUE}$RESET$BG_BLUE $branch$marks $RESET$FG_BLUE"
    	fi
    }

    __shorten_pwd() {
        local PRE= NAME="$1" LENGTH=30;
        [[ "$NAME" != "${NAME#$HOME/}" || -z "${NAME#$HOME}" ]] && PRE+='~' NAME="${NAME#$HOME}" LENGTH=$[LENGTH-1];
        ((${#NAME}>$LENGTH)) && NAME="/...${NAME:$[${#NAME}-LENGTH+4]}";
        echo "$PRE$NAME"
    }


    ps1() {

        PS1="\[\e]0;${TERM_TAB_TITLE}\a\]"

        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        if [ $? -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
	    local FG_EXIT="$FG_GREEN"
        else
            local BG_EXIT="$BG_RED"
	    local FG_EXIT="$FG_RED"
        fi

        PS1+=`[[ ! -z $VIRTUAL_ENV ]] && echo "$FG_VENV$BG_VENV$BOLD #$(basename ${VIRTUAL_ENV}) "`
        if [ ! -z $VIRTUAL_ENV ]; then
            if [ $(id -u) -eq 0 ]; then
                PS1+="$FG_VENV_E$BG_RED"
            else
                PS1+="$FG_VENV_E$BG_COLOR1"
            fi
            PS1+="$RESET"
        fi

        # Check root alert --> username
    	if [ $(id -u) -eq 0 ]; then
    		PS1+="$FG_COLOR1$BG_RED ${TERM_USERNAME} $FG_RED"
    	else
    		PS1+="$FG_COLOR1$BG_COLOR1 ${TERM_USERNAME} $FG_COLOR2"
    	fi

        PS1+="$BG_HOSTNAME"
        PS1+="$FG_COLOR3$BG_HOSTNAME$BOLD ${TERM_HOSTNAME} "
        PS1+="$RESET"

        PS1+="$FG_HOSTNAME$BG_COLOR4"
        PS1+="$FG_COLOR5$BG_COLOR5 $(__shorten_pwd $PWD) "
    	PS1+="$RESET"

        PS1+="$FG_COLOR6$(__git_info)"
        PS1+="$BG_EXIT"
        PS1+="$RESET"

        # PS1+="$BG_EXIT$FG_BASE3$BLINK ${PS_SYMBOL} "
        # PS1+="${RESET}"
        PS1+="${FG_EXIT}${RESET} "
    }

    PROMPT_COMMAND=ps1
}

export TERM_TAB_TITLE='\u@\h'
function set-term-title() {
    export TERM_TAB_TITLE="$*"
}

export TERM_USERNAME='\u'
function set-term-username() {
    export TERM_USERNAME="$*"
}

export TERM_HOSTNAME='\h'
function set-term-hostname() {
    export TERM_HOSTNAME="$*"
}

export TERM_GIT_STATUS=''
function set-term-git-status() {
    export TERM_GIT_STATUS="$*"
}

__powerline
unset __powerline
