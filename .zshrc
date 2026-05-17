#zmodload zsh/zprof
##########
# HISTORY
##########


typeset -U path PATH fpath FPATH
autoload colors; colors;

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
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
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
alias hg='history | grep --color=auto'

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
alias monsterclean='git clean -fdx -e .jj/'
alias gst='git status'
alias gaa='git add -A'
alias ga='git add'
alias gc='git commit'
alias gcm='git checkout trunk || git checkout main || git checkout master' 
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
alias upl='git push --force-with-lease'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'

# jj
alias jjpb="jj log -r 'latest(heads(ancestors(@) & bookmarks()), 1)' --limit 1 --no-graph --ignore-working-copy -T bookmarks | tr -d '*'"

jj-update-branch() {
  local rev="${1:-@}"
  if [ $# -gt 0 ]; then
    shift
  fi
  jj bookmark move "$(jjpb)" --to "$rev" "$@"
}

alias jjub=jj-update-branch
alias jn='jj new'
alias jc='jj commit'
alias jst='jj status'
alias jf='jj git fetch'
alias jp='jj git push'
alias jd='jj diff'
alias jrt='jj retrunk'
jjlt() {
  local n="${1:-10}"
  jj log -r "latest(ancestors(trunk()), $n)" --color=always -T '
    change_id.shortest(8) ++ " " ++
    commit_id.shortest(8) ++ " " ++
    "§" ++ author.email() ++ "§{" ++
    committer.timestamp().ago() ++ "{" ++
    if(bookmarks, bookmarks ++ " ", "") ++
    description.first_line()
  ' | column -t -s '{' | perl -pe '
    BEGIN {
      @colors = (1,2,3,5,6,9,10,11,12,13,14,33,39,41,47,50,51,82,118,154,166,172,196,199,208,214,220,226);
      sub colorize {
        my $e = shift;
        $e =~ s/\e\[[0-9;]*m//g;
        my $h = 0;
        $h += ord($_) for split("", $e);
        my $c = $colors[$h % scalar(@colors)];
        return "\e[38;5;${c}m$e\e[0m";
      }
    }
    s/§([^§]+)§/colorize($1)/ge
  ' | less -XFRS
}
alias jl='jj log'
alias jlr='jj lr'

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

alias p='pnpm'
alias pd='pnpm dev'
alias pc='pnpm check'
alias pf='pnpm check:fix'
alias pt='pnpm test --run'

##########
# FUNCTIONS
##########

mkdircd() {
    mkdir -p "$1" && cd "$1"
}

render_dot() {
  local out="${1}.png"
  dot "${1}" \
    -Tpng \
    -Nfontname='JetBrains Mono' \
    -Nfontsize=10 \
    -Nfontcolor='#fbf1c7' \
    -Ncolor='#fbf1c7' \
    -Efontname='JetBrains Mono' \
    -Efontcolor='#fbf1c7' \
    -Efontsize=10 \
    -Ecolor='#fbf1c7' \
    -Gbgcolor='#1d2021' > "${out}" || return

  if command -v kitten >/dev/null; then
    kitten icat --align=left "${out}"
  else
    open "${out}"
  fi
}

beautiful() {
  local i=0
  while
  do
    i=$((i + 1)) && echo -en "\x1b[3$(($i % 7))mo" && sleep .2
  done
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

jj_prompt_info() {
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"
  local clean=""
  local conflicts="%{$fg_bold[yellow]%} !%{$reset_color%}"

  local bookmark=$(jj log -r @ --no-graph -T 'bookmarks' 2> /dev/null | tr -d '*' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  local change_id=$(jj log -r @ --no-graph -T 'change_id.shortest()' 2> /dev/null) || return

  local wc_status=""
  if jj status | grep -q "Working copy changes:"; then
    wc_status=$dirty
  elif jj log -r @ --no-graph -T 'conflict' 2> /dev/null | grep -q "true"; then
    wc_status=$conflicts
  else
    wc_status=$clean
  fi

  local ref_display="${bookmark:-$change_id}"
  echo " %{$fg_bold[green]%}${ref_display}${wc_status}%{$reset_color%}"
}

vcs_prompt_info() {
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"
  local clean=""

  if [[ "$VCS_PROMPT_MODE" == "git" ]]; then
    local dirstatus="$clean"
    if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
      dirstatus=$dirty
    fi

    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
    echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
    return
  fi

  if command -v jj &>/dev/null && jj status &>/dev/null; then
    jj_prompt_info
    return
  fi

  local dirstatus="$clean"
  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
}

prompt_git_mode() {
  export VCS_PROMPT_MODE="git"
  echo "Switched to git prompt mode"
}

prompt_jj_mode() {
  unset VCS_PROMPT_MODE
  echo "Switched to jj prompt mode (default)"
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



simple_prompt() {
  local prompt_color="%B"
  export PROMPT="%{$prompt_color%}$promptnormal"
}

PROMPT='${dir_info}$(vcs_prompt_info) $promptnormal'

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

if type nvim &> /dev/null; then
  alias vi="nvim"
  export EDITOR="nvim"
  export PSQL_EDITOR='nvim -c "set filetype=sql"'
  export GIT_EDITOR="nvim"
else
  export EDITOR='vi'
  export PSQL_EDITOR='vi -c "set filetype=sql"'
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# commented the working code and replaced it with this other version
#PQ_LIB_DIR="$(brew --prefix libpq)/lib"
PQ_LIB_DIR="/opt/homebrew/opt/libpq/lib"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


##export JAVA_HOME=$(/usr/libexec/java_home)
##export PATH=$JAVA_HOME/bin:$PATH
#
#export JAVA_HOME=$(/usr/libexec/java_home -v 17)
##export JAVA_HOME=$(/usr/libexec/java_home -v 11)
##export JAVA_HOME=$(/usr/libexec/java_home -v 22)
#export PATH=$JAVA_HOME/bin:$PATH
#
# pnpm
export PNPM_HOME="/Users/blouse_man/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
#





# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
#
#
#
# this one works pretty good 
#[[ ! -r '/Users/blouse_man/.opam/opam-init/init.zsh' ]] || source '/Users/blouse_man/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
#
#
#
#
# END opam configuration
#
#
# Lazy-load opam so shell startup does not source its completion/env hooks.
if command -v opam >/dev/null; then
  opam() {
    unfunction "$0"
    [[ ! -r "${HOME}/.opam/opam-init/init.zsh" ]] || source "${HOME}/.opam/opam-init/init.zsh" >/dev/null 2>&1
    command opam "$@"
  }
fi

#source <(fzf --zsh)
export GPG_TTY=$(tty) # or /Users/blouse_man/.bashrc if you use bash

[[ -d "/opt/homebrew/opt/sevenzip/bin" ]] && export PATH="/opt/homebrew/opt/sevenzip/bin:$PATH"

cr() {
  open "${1:-.}" -a "Cursor"
}

vs() {
  open "${1:-.}" -a "Visual Studio Code"
}

if command -v rbenv >/dev/null; then
    eval "$(rbenv init - --no-rehash zsh)"
fi

#zprof
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/blouse_man/.docker/completions $fpath)
# End of Docker CLI completions

autoload -U +X bashcompinit && bashcompinit
[[ -x /opt/homebrew/bin/terraform ]] && complete -o nospace -C /opt/homebrew/bin/terraform terraform

command -v jj >/dev/null && source <(COMPLETE=zsh jj)
if command -v opencode >/dev/null; then
  local opencode_completion_cache="${HOME}/.zcompcache/opencode.zsh"
  if [[ ! -s "$opencode_completion_cache" || "$opencode_completion_cache" -ot "$(command -v opencode)" ]]; then
    mkdir -p "${opencode_completion_cache:h}"
    opencode completion >| "$opencode_completion_cache"
  fi
  source "$opencode_completion_cache"
fi
alias g++="/opt/homebrew/bin/g++-15"
# export PATH="/opt/homebrew/opt/binutils/bin:$PATH"  # Commented out - conflicts with macOS ar
alias clang+++="clang++ -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1"

# Added by Antigravity
export PATH="/Users/blouse_man/.antigravity/antigravity/bin:$PATH"


export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
for haskell_path in "$HOME/.ghcup/bin" "$HOME/.cabal/bin"; do
  [[ -d "$haskell_path" ]] && PATH="$haskell_path:$PATH"
done

path=(${(@)path:#/Users/blouse_man/.local/bin/zig})
path=(${(@)path:#/Users/blouse_man/.local/share/nvim/lazy/fzf/bin})
export PATH
