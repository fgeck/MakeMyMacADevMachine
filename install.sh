#!/bin/bash

# --- Copy dotfiles for zsh ---
cp -f dotfiles/.zshrc "$HOME"/.zshrc
mkdir -p "$HOME"/.dotfiles "$HOME"/.age "$HOME"/.ssh
cp -f dotfiles/aliases "$HOME"/.dotfiles/
cp -f .p10k.zsh "$HOME"/.p10k.zsh

# --- Brew ---
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=/opt/homebrew/bin:$PATH
brew update
brew doctor
brew tap sdkman/tap

# --- oh-my-zsh (RUNZSH=no supresses shell switch) ---
sh -c "RUNZSH=no; $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# --- Zsh Mods ---
# Do not forget to change fonts: 
# iTerm → Preferences → Profiles → Text → Change Font -> MesloLGS NF
brew install \
  font-hack-nerd-font \
  powerlevel10k \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  jandedobbeleer/oh-my-posh/oh-my-posh
brew install --cask font-meslo-lg-nerd-font
git clone https://github.com/romkatv/zsh-defer.git "$HOME"/zsh-defer

# --- Languages ---
brew install golang golangci-lint python pyenv sdkman-cli nvm
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
sdk install java 21.0.5-jbr
sdk install kotlin
mkdir ~/.nvm
nvm install node
# maven has to be installed after java
brew install maven gradle


# -- Usefule cli tools ---
brew install \
  hub \
  tree \
  vim \
  wget \
  jq \
  yq \
  fzf \
  tldr \
  tmux \
  thefuck \
  ranger \
  htop \
  watch \
  zoxide \
  bat \
  go-task \
  bitwarden-cli

# --- Cloud & Network ---
brew install \
  kubernetes-cli \
  kubectx \
  krew \
  helm \
  helmfile \
  fluxcd/tap/flux \
  sops \
  awscli \
  openssl \
  mtr \
  nmap \
  arping \
  mitmproxy \
  gobuster \

kubectl krew install tree edit-status


# --- Dev tools ---
brew install --cask iterm2 docker utm intellij-idea-ce visual-studio-code bruno
# ---Statusbar tools ---
brew install --cask hiddenbar stats rectangle alt-tab itsycal
# --- Other Programms ---
brew install --cask vlc signal telegram firefox google-chrome bitwarden

# --- OSX configs ---
# Show Library
chflags nohidden ~/Library
# Show Hidden Files
defaults write com.apple.finder AppleShowAllFiles YES
# Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true
# Show status Bar
defaults write com.apple.finder ShowStatusBar -bool true

echo "installation done! You have to manually import the iterm2 profile"
echo ""
