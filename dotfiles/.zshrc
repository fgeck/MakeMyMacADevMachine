# ---- Powerlevel10k Instant Prompt ----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- Environment Variables ----
export FZF_BASE=/opt/homebrew/opt/fzf
export ZSH="$HOME/.oh-my-zsh"
export SDKMAN_DIR=$(/opt/homebrew/bin/brew --prefix sdkman-cli)/libexec
export NVM_DIR="$HOME/.nvm"
export GOPATH=$HOME/go
export GOARCH=arm64
export CGO_ENABLED=1
export CGO_LDFLAGS_ALLOW=.*
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"
export KUBECONFIG="$HOME/.kube/config"
export SOPS_AGE_KEY_FILE=$HOME/.age/key.txt

# ---- PATH Optimization ----
export PATH="/opt/homebrew/opt/curl/bin:/usr/local/kubebuilder/bin:${KREW_ROOT:-$HOME/.krew}/bin:/usr/local/bin/flutter/bin:$GOPATH/bin:/opt/homebrew/bin:/opt/homebrew/opt/libpq/bin:$PATH"

# ---- Oh-My-Zsh Configuration ----
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
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
source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k Config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ---- Additional Configuration ----
[[ -f $HOME/.dotfiles/aliases ]] && source $HOME/.dotfiles/aliases
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

# ---- SDKs & Language Managers ----
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# ---- Auto Completions ----
autoload -U compinit && compinit

# Lazy-load plugins & scripts
if command -v zsh-defer >/dev/null 2>&1; then
  zsh-defer source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  zsh-defer source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  zsh-defer eval "$(zoxide init zsh)"
  zsh-defer eval "$(task --completion zsh)"
  
  # Lazy-load completions only if commands exist
  [[ $commands[kubectl] ]] && zsh-defer source <(kubectl completion zsh)
  [[ $commands[flux] ]] && zsh-defer source <(flux completion zsh)
else
  # Fallback if `zsh-defer` is not installed
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  eval "$(zoxide init zsh)"
  eval "$(task --completion zsh)"
  
  [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
  [[ $commands[flux] ]] && source <(flux completion zsh)
fi
