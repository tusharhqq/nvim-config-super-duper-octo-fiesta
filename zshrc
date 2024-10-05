#zmodload zsh/zprof
##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt INC_APPEND_HISTORY     # Immediately append to history file.
setopt EXTENDED_HISTORY       # Record timestamp in history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.
setopt SHARE_HISTORY          # Share history between all sessions.
unsetopt HIST_VERIFY          # Execute commands using history (e.g.: using !$) immediately

#############
# COMPLETION
#############

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

# Speed up completion init, see: https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# unsetopt menucomplete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

###############
# KEY BINDINGS
###############

# Vim Keybindings
bindkey -v

# This is a "fix" for zsh in Ghostty:
# Ghostty implements the fixterms specification https://www.leonerd.org.uk/hacks/fixterms/
# and under that `Ctrl-[` doesn't send escape but `ESC [91;5u`.
#
# (tmux and Neovim both handle 91;5u correctly, but raw zsh inside Ghostty doesn't)
#
# Thanks to @rockorager for this!
bindkey "^[[91;5u" vi-cmd-mode

# Open line in Vim by pressing 'v' in Command-Mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Push current line to buffer stack, return to PS1
bindkey "^Q" push-input

# Make up/down arrow put the cursor at the end of the line
# instead of using the vi-mode mappings for these keys
bindkey "\eOA" up-line-or-history
bindkey "\eOB" down-line-or-history
bindkey "\eOC" forward-char
bindkey "\eOD" backward-char

# CTRL-R to search through history
bindkey '^R' history-incremental-search-backward
# CTRL-S to search forward in history
bindkey '^S' history-incremental-search-forward
# Accept the presented search result
bindkey '^Y' accept-search

# Use the arrow keys to search forward/backward through the history,
# using the first word of what's typed in as search word
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Use the same keys as bash for history forward/backward: Ctrl+N/Ctrl+P
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Backspace working the way it should
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char

# Some emacs keybindings won't hurt nobody
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Where should I put you?
bindkey -s '^F' "tmux-sessionizer\n"

#########
# Aliases
#########

case $OSTYPE in
 darwin*)
    local aliasfile="${HOME}/.zsh.d/aliases.Darwin.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
esac

if type lsd &> /dev/null; then
  alias ls=lsd
fi
alias lls='ls -lh --sort=size --reverse'
alias llt='ls -lrt'
alias bear='clear && echo "Clear as a bear!"'

alias history='history 1'
alias hs='history | grep '

# Use rsync with ssh and show progress
alias rsyncssh='rsync -Pr --rsh=ssh'

# Edit/Source nvim config
alias ez='vi ~/.zshrc'
alias sz='source ~/.zshrc'

#fzf 
alias ea='nvim $(fzf --preview="cat {}")'
#alias fkf ='nvim $(fzf --preview="cat {}")'
#vi $(fzf --preview='cat {}')
#nvim $(fzf --preview='cat {}')

# git
alias gst='git status'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git checkout trunk'
alias gd='git diff'
alias gdc='git diff --cached'
# [c]heck [o]ut
alias co='git checkout'
# [f]uzzy check[o]ut
fo() {
  git branch --no-color --sort=-committerdate --format='%(refname:short)' | fzf --header 'git checkout' | xargs git checkout
}
# [p]ull request check[o]ut
po() {
  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-5)}' | xargs git checkout
}
alias up='git push'
alias upf='git push --force'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'

# tmux
alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tmm='tmux new -s main'
# ceedee dot dot dot
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Go
alias got='go test ./...'

alias k='kubectl'

alias -g withcolors="| sed '/PASS/s//$(printf "\033[32mPASS\033[0m")/' | sed '/FAIL/s//$(printf "\033[31mFAIL\033[0m")/'"

alias zedn='/Applications/Zed\ Nightly.app/Contents/MacOS/cli'
alias r='cargo run'
alias rr='cargo run --release'

##########
# FUNCTIONS
##########

mkdircd() {
    mkdir -p $1 && cd $1
}

spinner() {
    while
    do
        for i in "-" "\\" "|" "/"
        do
            echo -n " $i \r\r"
            sleep .1
        done
    done
}

# Open PR on GitHub
pr() {
  if type gh &> /dev/null; then
    gh pr view -w
  else
    echo "gh is not installed"
  fi
}


#########
# PROMPT
#########

setopt prompt_subst

git_prompt_info() {
  local dirstatus=" OK"
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"

  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
}

# local dir_info_color="$fg_bold[black]"

# This just sets the color to "bold".
# Future me. Try this to see what's correct:
#   $ print -P '%fg_bold[black] black'
#   $ print -P '%B%F{black} black'
#   $ print -P '%B black'
local dir_info_color="%B"

local dir_info_color_file="${HOME}/.zsh.d/dir_info_color"
if [ -r ${dir_info_color_file} ]; then
  source ${dir_info_color_file}
fi

local dir_info="%{$dir_info_color%}%(5~|%-1~/.../%2~|%4~)%{$reset_color%}"
local promptnormal="φ %{$reset_color%}"
local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"

# Show how many nested `nix shell`s we are in
# local nix_prompt=""
# # Set ORIG_SHLVL only if it wasn't previously set and if SHLVL > 1 and
# # GHOSTTY_RESOURCES_DIR is not empty
# if [[ -z $ORIG_SHLVL ]]; then
#   if [[ -z $GHOSTTY_RESOURCES_DIR ]]; then
#     export ORIG_SHLVL=$SHLVL
#   elif  [[ $SHLVL -gt 1 ]]; then
#     export ORIG_SHLVL=$SHLVL
#   fi
# fi;
# # If ORIG_SHLVL is set and SHLVL is now greater: display nesting level
# if [[ ! -z $ORIG_SHLVL && $SHLVL -gt $ORIG_SHLVL ]]; then
#   nix_prompt=("(%F{yellow}$(($SHLVL - $ORIG_SHLVL))%f) ")
# fi;

PROMPT='${dir_info}$(git_prompt_info) ${nix_prompt}%(1j.$promptjobs.$promptnormal)'

simple_prompt() {
  local prompt_color="%B"
  export PROMPT="%{$prompt_color%}$promptnormal"
}

#########
# PROMPT
#########

setopt prompt_subst

git_prompt_info() {
  local dirstatus=" OK"
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"

  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
}

# local dir_info_color="$fg_bold[black]"

# This just sets the color to "bold".
# Future me. Try this to see what's correct:
#   $ print -P '%fg_bold[black] black'
#   $ print -P '%B%F{black} black'
#   $ print -P '%B black'
local dir_info_color="%B"

local dir_info_color_file="${HOME}/.zsh.d/dir_info_color"
if [ -r ${dir_info_color_file} ]; then
  source ${dir_info_color_file}
fi

local dir_info="%{$dir_info_color%}%(5~|%-1~/.../%2~|%4~)%{$reset_color%}"
local promptnormal="φ %{$reset_color%}"
local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"

# Show how many nested `nix shell`s we are in
# local nix_prompt=""
# # Set ORIG_SHLVL only if it wasn't previously set and if SHLVL > 1 and
# # GHOSTTY_RESOURCES_DIR is not empty
# if [[ -z $ORIG_SHLVL ]]; then
#   if [[ -z $GHOSTTY_RESOURCES_DIR ]]; then
#     export ORIG_SHLVL=$SHLVL
#   elif  [[ $SHLVL -gt 1 ]]; then
#     export ORIG_SHLVL=$SHLVL
#   fi
# fi;
# # If ORIG_SHLVL is set and SHLVL is now greater: display nesting level
# if [[ ! -z $ORIG_SHLVL && $SHLVL -gt $ORIG_SHLVL ]]; then
#   nix_prompt=("(%F{yellow}$(($SHLVL - $ORIG_SHLVL))%f) ")
# fi;

PROMPT='${dir_info}$(git_prompt_info) ${nix_prompt}%(1j.$promptjobs.$promptnormal)'

simple_prompt() {
  local prompt_color="%B"
  export PROMPT="%{$prompt_color%}$promptnormal"
}

########
# ENV
########

export COLOR_PROFILE="dark"

case $OSTYPE in
 darwin*)
    local envfile="${HOME}/.zsh.d/env.Darwin.sh"
    [[ -e ${envfile} ]] && source ${envfile}
  ;;
esac

export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Reduce delay for key combinations in order to change to vi mode faster
# See: http://www.johnhawthorn.com/2012/09/vi-escape-delays/
# Set it to 10ms
export KEYTIMEOUT=1

export PATH="$HOME/neovim/bin:$PATH"

if type nvim &> /dev/null; then
  alias vi="nvim"
  export EDITOR="nvim"
  export PSQL_EDITOR="nvim -c"set filetype=sql""
  export GIT_EDITOR="nvim"
else
  export EDITOR='vi'
  export PSQL_EDITOR='vi -c"set filetype=sql"'
  export GIT_EDITOR='vi'
fi

if [[ -e "$HOME/code/clones/lua-language-server/3rd/luamake/luamake" ]]; then
  alias luamake="$HOME/code/clones/lua-language-server/3rd/luamake/luamake"
fi

# fzf
if type fzf &> /dev/null && type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# direnv
if type direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi








export PATH=$PATH:/Users/blouse_man/go/bin

alias vi="nvim"

# bun completions
[ -s "/Users/blouse_man/.bun/_bun" ] && source "/Users/blouse_man/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
PQ_LIB_DIR="$(brew --prefix libpq)/lib"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


#export JAVA_HOME=$(/usr/libexec/java_home)
#export PATH=$JAVA_HOME/bin:$PATH

export JAVA_HOME=$(/usr/libexec/java_home -v 17)
#export JAVA_HOME=$(/usr/libexec/java_home -v 11)
#export JAVA_HOME=$(/usr/libexec/java_home -v 22)
export PATH=$JAVA_HOME/bin:$PATH

export ANDROID_HOME=/Users/blouse_man/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# pnpm
export PNPM_HOME="/Users/blouse_man/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
#
export PATH=$PATH:/opt/homebrew/bin






#zprof



# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/blouse_man/.opam/opam-init/init.zsh' ]] || source '/Users/blouse_man/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

source <(fzf --zsh)
export GPG_TTY=$(tty) # or /Users/blouse_man/.bashrc if you use bash
