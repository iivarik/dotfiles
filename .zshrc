# Plain zsh, no framework. Plugins come from apt (pinned by the Ubuntu release).

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# Use the systemd ssh-agent (WSL doesn't set this); keys are added on first use
# via AddKeysToAgent in ~/.ssh/config
if [[ -z $SSH_AUTH_SOCK && -S $XDG_RUNTIME_DIR/openssh_agent ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/openssh_agent"
fi

# ---------------------------------------------------------------------------
# Options & history
# ---------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt extended_history share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks
setopt auto_cd auto_pushd pushd_ignore_dups interactive_comments

# Emacs-style line editing; up/down search history by the typed prefix
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;5C' forward-word   # ctrl+right
bindkey '^[[1;5D' backward-word  # ctrl+left
bindkey '^[[3~' delete-char

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# ---------------------------------------------------------------------------
# Prompt: branch (green = clean, red = dirty) [cwd]$
# ---------------------------------------------------------------------------
_git_prompt() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
  if [[ -n $(git status --porcelain 2>/dev/null | head -n1) ]]; then
    print -n "%F{red}${branch}%f"
  else
    print -n "%F{green}${branch}%f"
  fi
}
setopt prompt_subst
PROMPT='$(_git_prompt)%F{cyan}[%~]%f%B$%b '

# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------
if (( $+commands[vivid] )); then
  export LS_COLORS="$(vivid generate gruvbox-dark)"
else
  eval "$(dircolors -b)"
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if (( $+commands[eza] )); then
  export EZA_COLORS="da=38;5;172"
  alias ls="eza"
  alias l="eza -l"
  alias la="eza -la"
  alias lt="eza --git-ignore -T -a -I=.git"
fi

export BAT_THEME="gruvbox-dark"
(( $+commands[bat] )) && alias cat="bat"

# fzf: ctrl+r history search, ctrl+t file search, alt+c cd
(( $+commands[fzf] )) && source <(fzf --zsh)

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias vim="nvim"
alias zshcfg="nvim ~/.zshrc"
alias tmuxcfg="nvim ~/.config/tmux/tmux.conf"
alias nvimcfg="nvim ~/.config/nvim"
alias clr="clear"
alias ...="cd ../.."

# git (the oh-my-zsh ones that matter)
alias g="git"
alias gs="git status --short --branch"
alias gst="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -v"
alias gcm="git commit -m"
alias gco="git checkout"
alias gsw="git switch"
alias gb="git branch"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git pull"
alias gp="git push"
alias glog="git log --oneline --decorate --graph"
alias lg="lazygit"

# tmux
alias ta="tmux attach -t"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"

# ---------------------------------------------------------------------------
# Machine-specific settings (not in the repo)
# ---------------------------------------------------------------------------
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

# Plugins (syntax highlighting must be sourced last)
[[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
