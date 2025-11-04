# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  zsh-vi-mode
  git
  zsh-autosuggestions
  zsh-syntax-highlighting # must be the last plugin sourced
)

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#af00ff"

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

if [ -f ~/.env ]; then
  . ~/.env
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#### PATH ####

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# GO PATH
export PATH=$PATH:/opt/homebrew/Cellar/go/1.20.5/
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Rust PATH
export CARGO_PATH=$HOME/.cargo
export PATH=$CARGO_PATH/bin:$PATH

#nvm PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bun path
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Java Path
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH=$JAVA_HOME/bin:$PATH

# GraalVM
export GRAALVM_HOME=$HOME/.sdkman/candidates/java/21.0.1-graalce
export PATH=$GRAALVM_HOME/bin:$PATH

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

# Set engine to either "colima" or "podman"
export engine="podman"

if [ "$engine" = "colima" ]; then
    export COLIMA_VM="default"
    # export COLIMA_VM="x86-vm"
    export COLIMA_VM_SOCKET="${HOME}/.colima/${COLIMA_VM}/docker.sock"
    export DOCKER_HOST="unix://${COLIMA_VM_SOCKET}"
    export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=$COLIMA_VM_SOCKET
elif [ "$engine" = "podman" ]; then
    export DOCKER_HOST="unix:///var/run/docker.sock"
    export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

    alias docker=podman
    alias docker-compose=podman-compose
fi

export TESTCONTAINERS_RYUK_DISABLED=true

export TESTCONTAINERS_HOST_OVERRIDE=127.0.0.1

# set browser to use temp dir
export BROWSER="open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir=\"/tmp/chrome_dev_test\""

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Added by Windsurf
export PATH="/Users/jrakhman/.codeium/windsurf/bin:$PATH"

alias claude="/Users/jrakhman/.claude/local/claude"

eval "$(zoxide init zsh)"

cd_to_dir() {
    local base_dir="${1:-.}"  # Use argument or current directory
    local selected_dir
    local fd_opts=(--type d --follow --exclude .git)  # always directories only

    # Convert to absolute path to avoid duplicates
    base_dir=$(realpath "$base_dir" 2>/dev/null || echo "$base_dir")

    # Include hidden folders only if base_dir starts with '.'
    if [[ "$base_dir" == .* ]]; then
        fd_opts+=(--hidden)
    fi
    selected_dir=$(fd $fd_opts . "$base_dir" \
        | fzf --height 50% --preview 'tree -C -L 1 {}')

    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir" || return 1
        # Add to zoxide history
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

. "$HOME/.local/bin/env"

