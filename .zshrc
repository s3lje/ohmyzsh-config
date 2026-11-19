# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(zoxide init zsh)"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo extract)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ----------- SHELL VARS ------------
HISTSIZE=50000
SAVEHIST=50000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE    # cmds starting with space dont get saved
setopt SHARE_HISTORY        # save history across tabs

setopt AUTO_CD              # typing a dir name alone cds into it
setopt CORRECT              # offers corrections for mistyped cmds


# ----------- ALIASES --------------
alias ls="eza --icons=always"
alias ll="eza -la --icons=always --git"
alias cd="z"
alias mkcd="take"
alias cat="bat --paging=never"
alias grep="rg -n"
alias find="fd"

alias zshrc="${EDITOR:-nvim} ~/.zshrc"
alias reload='source ~/.zshrc'


# ----------- Keybindings -----------
bindkey "^[b" backward-word
bindkey "^[f" forward-word


# -------- cmd functions -----------

# cd..()
#
# similar to an alias, simply makes 'cd..' act as 'cd ..'
cd..() {
    cd ..
}


# up()
#
# moves up folder hierarchy by 1 or X folders with (up | up X)
up() {
    cd "$(printf '../%.0s' {1..${1:-1}})"
}


# proj()
#
# fuzzy-picks any subfolder of the Development folder in Documents
# with a preview
proj() {
    local dir
    dir=$(fd --type d --max-depth 2 . ~/Documents/Development |
        fzf --preview 'eza -la --icons=always {}') && cd "$dir"
}


# gitbr()
#
# git branch picker, sorted by most recent commit, with log preview
gitbr() {
    local branch
    branch=$(git branch --all --sort=-committerdate |
        sed 's/^[* ]*//; s#remotes/origin/##' |
        awk '!seen[$0]++' | grep -v HEAD |
        fzf --preview 'git log --oneline --color=always -20 {}') &&
        git checkout "$branch"
}


# bak()
#
# Makes a quick .bak backup copy of a file
bak() {
    cp -- "$1" "$1.bak"
}


# ts()
#
# ts attaches to a session named after currect directory, if one Documents
# exist, it creates it. ${PWD:t} is last path compontent
ts() {
    tmux new-session -A -s "${1:-${PWD:t}}"
}


# fkill()
#
# lets the user pick one or more processes with tab,
# and then press enter to kill them.
fkill() {
    local pids
    pids=$(ps -eo pid,user,%cpu,%mem,comm | sed 1d |
        fzf -m --header 'Tab to multi-select' | awk '{print $1}')
    [[ -n "$pids" ]] && echo "$pids" | xargs kill
}


# killport()
#
# kills off whatever process is using a specified port
killport() {
    local pid
    pid=$(lsof -ti tcp:"$1")
    if [[ -n "$pid" ]]; then
        kill "$pid"
        echo "Killed $pid using port: $1"
        return 0
    else
        "No service found on port $1"
        return 1
    fi
}

# rm()
#
# wrapper function for rm builtin.
# checks whether rm was ran with flags or not, and if its ran without,
# it checks if whats being deleted is a directory, if not, it simply 
# deletes it. But if it is a directory it asks the user if they meant
# to delete the directory and everything inside with a y|N prompt.
rm() {
    local arg has_flags=0 dirs=()

    # has user passed flags?
    for arg in "$@"; do
        [[ "$arg" == -* ]] && has_flags=1
    done

    # if flags, behave like normal rm
    if ((has_flags)); then
        command rm "$@"
        return
    fi

    # collect args that are directories (not symlinks)
    for arg in "$@"; do
        [[ -d "$arg" && ! -L "$arg" ]] && dirs+=("$arg")
    done
    
    # no directories: normal rm
    if (( ${#dirs} == 0 )); then
        command rm "$@"
        return
    fi

    print -r -- "These are directories:"
    printf '  %s\n\n' "${dirs[@]}"
    read -r "REPLY?Delete them (and everything inside) with rm -rf? [(y|rm)/N] "
    echo
    if [[ "${REPLY:l}" == (y|yes|rm) ]]; then
        command rm -rf "$@"
        printf '...\n'
        print -r -- '============================================='
        printf      'Deleted %d directories and everyting inside.\n' "${#dirs}"
        print -r -- '============================================='
    else
        echo "Aborted."
        return 1
    fi

}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$(brew --prefix)/opt/qt/bin:$PATH"
