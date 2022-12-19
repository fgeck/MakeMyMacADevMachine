#!/bin/bash

## Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=/opt/homebrew/bin:$PATH
brew update
brew doctor

# oh-my-zsh (RUNZSH=no supresses shell switch)
sh -c "RUNZSH=no; $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# powerlevel fonts and nerd fonts
# do not forget: iTerm → Preferences → Profiles → Text → Change Font
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# dotfiles for zsh
cp -f dotfiles/.zshrc $HOME/.zshrc
mkdir -p $HOME/.dotfiles
cp -f dotfiles/aliases dotfiles/functions $HOME/.dotfiles/
cp -f .p10k.zsh $HOME/.p10k.zsh

## CLI Tools, languages...
brew install golang golangci-lint python pyenv openjdk hub ffmpeg lame nmap \
            openssl tree vim wget jq yq fzf tldr tmux thefuck ranger mtr \
            htop kubernetes-cli kubectx helm awscli watch youtube-dl secretive

# krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
kubectl krew install tree edit-status


# maven has to be installed after java
brew install maven
# install node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install node

## Dev tools
brew install --cask iterm2 docker docker-machine intellij-idea-ce visual-studio-code postman
## Statusbar tools
brew install --cask hiddenbar stats rectangle alt-tab itsycal
## Programms
brew install --cask vlc signal telegram firefox google-chrome discord bitwarden

## Paswordmanager
brew tap amar1729/formulae
brew install coreutils gnu-sed gnupg browserpass pass pinentry pinentry-mac
PREFIX='/usr/local/opt/browserpass' make hosts-chrome-user -f '/usr/local/opt/browserpass/lib/browserpass/Makefile'
PREFIX='/usr/local/opt/browserpass' make hosts-firefox-user -f '/usr/local/opt/browserpass/lib/browserpass/Makefile'
sudo echo "pinentry-program $(echo $(which pinentry-mac))" > ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent

# configure vs code
code --install-extension akamud.vscode-theme-onedark
code --install-extension ban.spellright
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension donjayamanne.githistory
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.python
code --install-extension ms-vscode.Go
code --install-extension PKief.material-icon-theme
code --install-extension redhat.java
code --install-extension redhat.vscode-yaml
code --install-extension techer.open-in-browser
code --install-extension ziyasal.vscode-open-in-github

### osx configs
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
