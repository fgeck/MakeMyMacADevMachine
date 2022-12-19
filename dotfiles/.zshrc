# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export FZF_BASE=/opt/homebrew/opt/fzf
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  cp
  docker
  extract
  fzf
  git
  github
  gradle
  history
  jsontools
  rsync
  vscode
  pass
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_THEME="POWERLEVEL10K/POWERLEVEL10K"
source $ZSH/oh-my-zsh.sh
[ -f $HOME/.dotfiles/aliases ] && . $HOME/.dotfiles/aliases
[ -f $HOME/.dotfiles/functions ] && . $HOME/.dotfiles/functions

# DEV stuff
export GOPATH=$HOME/go
export GOARCH=arm64 # remove as soon as M1 is fully supported
# export GOARCH=amd64
PATH="/usr/local/opt/openjdk/bin:/usr/local/kubebuilder/bin:${KREW_ROOT:-$HOME/.krew}/bin:/usr/local/bin/flutter/bin:$GOPATH/bin:/opt/homebrew/bin:/opt/homebrew/opt/openjdk/bin:$PATH"
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"


# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
# kubernetes completion
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
