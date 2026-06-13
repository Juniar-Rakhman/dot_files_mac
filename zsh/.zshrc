if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# Core 
export EDITOR="nvim"

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.env ] && source ~/.env
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# PATH
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nightly/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Rust
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Java
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

# GraalVM
export GRAALVM_HOME="$HOME/.sdkman/candidates/java/21.0.1-graalce"
export PATH="$GRAALVM_HOME/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


# Node (NVM lazy init)
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}

[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"


# Container engine (Colima default, Podman optional)
export ENGINE="colima"

if [ "$ENGINE" = "colima" ]; then
  export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

  export DOCKER_BUILDKIT=1
  export COMPOSE_DOCKER_CLI_BUILD=1

  export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="$DOCKER_HOST"
  export TESTCONTAINERS_RYUK_DISABLED=false
  export TESTCONTAINERS_HOST_OVERRIDE=host.docker.internal

  alias dcu="docker compose up -d"
  alias dcd="docker compose down"
fi

if [ "$ENGINE" = "podman" ]; then
  export DOCKER_HOST="unix:///var/run/docker.sock"

  export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="$DOCKER_HOST"
  export TESTCONTAINERS_RYUK_DISABLED=true
  export TESTCONTAINERS_HOST_OVERRIDE=127.0.0.1

  alias docker=podman
  alias docker-compose=podman-compose
  alias dcu="podman-compose up -d"
  alias dcd="podman-compose down"
fi


# Tools
eval "$(zoxide init zsh)"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -s "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"


# yazi wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"

  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}


# cd helpers
cd_to_dir() {
  local base_dir="${1:-.}"
  local selected_dir
  local fd_opts=(--type d --follow --exclude .git)

  base_dir=$(realpath "$base_dir" 2>/dev/null || echo "$base_dir")

  if [[ "$base_dir" == .* ]]; then
    fd_opts+=(--hidden)
  fi

  selected_dir=$(fd $fd_opts . "$base_dir" \
    | fzf --height 50% --preview 'tree -C -L 1 {}')

  if [[ -n "$selected_dir" ]]; then
    cd "$selected_dir" || return 1
    zoxide add "$selected_dir"
  fi
}

alias zc='cd_to_dir'

zcd() {
  local dir
  dir=$(zoxide query -l | fzf --height 50% --preview 'tree -C -L 1 {}' --query="$1")
  if [[ -n "$dir" ]]; then
    z "$dir"
  fi
}

alias zz='zcd'


# Browser sandbox
export BROWSER="open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir=\"/tmp/chrome_dev_test\""


# Build tools flags
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1


# SDKMAN (must be LAST heavy tool)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
