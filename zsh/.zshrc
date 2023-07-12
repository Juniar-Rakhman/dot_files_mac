# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/Users/jrakhman/.oh-my-zsh"

# Plugins
plugins=(
    git
    colored-man-pages
    zsh-autosuggestions
    zsh-interactive-cd
    zsh-syntax-highlighting
    # zsh-vi-mode # doesn't work if zsh-syntax-highlighting is on
)

ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nvim'
else
    export EDITOR='nvim'
fi

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# AUTOSUGGEST_config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#af00ff"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export GIT_EDITOR=nvim

# GraalVM path
export GRAALVM_HOME=$HOME/.sdkman/candidates/java/22.3.1.r17-grl/
export PATH=$GRAALVM_HOME/bin:$PATH

# GO PATH
export PATH=$PATH:/opt/homebrew/Cellar/go/1.20.5/
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Rust PATH
export CARGO_PATH=$HOME/.cargo
export PATH=$CARGO_PATH/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Docker settings
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"
# export COMPOSE_DOCKER_CLI_BUILD=1
# export DOCKER_BUILDKIT=1
# export DOCKER_DEFAULT_PLATFORM=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
