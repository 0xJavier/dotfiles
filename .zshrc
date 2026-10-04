# --- Colors & Prompt --- 


# Enable colors for ls
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GF'

# Load zsh's color helper
autoload -U colors && colors

# Highlight matches in grep
alias grep='grep --color=auto'

# Colored tab-completion menus that match your ls colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# --- Navigation & completion ---


# Type a directory name on its own to cd into it
setopt AUTO_CD

# Turn on zsh's completion system
autoload -Uz compinit && compinit

# Arrow-key selectable completion menu
zstyle ':completion:*' menu yes select

# Color the menu entries to match your ls colors
export LS_COLORS='di=1;34:ln=1;35:so=1;31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# --- Prompt ---


setopt PROMPT_SUBST

git_prompt_info() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return

  local color=green                                   # clean
  [[ -n $(git status --porcelain 2>/dev/null) ]] && color=red   # uncommitted changes

  local info=" on %F{$color}${branch}%f"

  local ahead
  ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
  if [[ -n $ahead && $ahead -gt 0 ]]; then
    info+=" %F{magenta}with ${ahead} unpushed%f"      # committed but not pushed
  fi

  echo "$info"
}

prompt_dir() {
  if [[ $PWD == $HOME ]]; then
    echo "Home"
  elif [[ $PWD == / ]]; then
    echo "/"
  else
    echo "%1d/"
  fi
}

PROMPT='%F{cyan}%n%f in %F{blue}$(prompt_dir)%f$(git_prompt_info) %# '