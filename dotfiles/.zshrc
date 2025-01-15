# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export FZF_BASE=/opt/homebrew/opt/fzf
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  asdf
  aws
  cp
  docker
  extract
  fzf
  git
  github
  gradle
  history
  jsontools
  kubectl
  kubectx
  rsync
  vscode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_THEME="POWERLEVEL10K/POWERLEVEL10K"
source $ZSH/oh-my-zsh.sh
[ -f $HOME/.dotfiles/aliases ] && . $HOME/.dotfiles/aliases
[ -f $HOME/.dotfiles/functions ] && . $HOME/.dotfiles/functions

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" 

# DEV stuff
export GOPATH=$HOME/go
export GOARCH=arm64
export CGO_ENABLED=1
export CGO_LDFLAGS_ALLOW=.*

PATH="/opt/homebrew/opt/curl/bin:/usr/local/kubebuilder/bin:${KREW_ROOT:-$HOME/.krew}/bin:/usr/local/bin/flutter/bin:$GOPATH/bin:/opt/homebrew/bin:/opt/homebrew/opt/libpq/bin/:$PATH"

export ANDROID_NDK_HOME="/usr/local/share/android-ndk"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'


# export KUBECONFIG="$HOME/.kube/config"
export PATH=$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# oh-my-posh instead of powerlevel10k
# if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
#   CONFIG="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/powerlevel10k_modern.omp.json"
#   CONFIG="$HOME/.dotfiles/oh-my-posh-themes/fgeck.yaml"
#   eval "$(oh-my-posh init zsh --config $CONFIG)"
# fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
autoload -U compinit; compinit

# kubernetes completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# sdkman 
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

export SOPS_AGE_KEY_FILE=$HOME/.age/key.txt

eval "$(zoxide init zsh)"
eval "$(task --completion zsh)"
. <(flux completion zsh)
