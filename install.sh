#!/bin/bash

# --- Install US with German Umlauts ---
curl -sL https://api.github.com/repos/patrick-zippenfenig/us-with-german-umlauts/tarball/master | sudo tar xz --exclude=README.md --strip=1 -C /Library/Keyboard\ Layouts/
echo "Open System Preferences -> Keyboard -> Input Sources"
echo "Add U.S. with German Umlauts (category English) (Note: If the keyboard is not displayed, you may have to restart your device)"

# --- Copy dotfiles for zsh ---
cp -f dotfiles/.zshrc "$HOME"/.zshrc
mkdir -p "$HOME"/.dotfiles "$HOME"/.age "$HOME"/.ssh
cp -f dotfiles/aliases "$HOME"/.dotfiles/
cp -f dotfiles/.p10k.zsh "$HOME"/.p10k.zsh

# --- Brew ---
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=/opt/homebrew/bin:$PATH
brew update
brew doctor
brew tap sdkman/tap

# --- oh-my-zsh (RUNZSH=no supresses shell switch) ---
# https://ohmyz.sh/
sh -c "RUNZSH=no; $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# --- Zsh Mods ---
# https://github.com/romkatv/powerlevel10k https://github.com/zsh-users/zsh-autosuggestions https://github.com/zsh-users/zsh-syntax-highlighting https://ohmyposh.dev/
# Do not forget to change fonts: 
# iTerm → Preferences → Profiles → Text → Change Font -> MesloLGS NF
brew install \
  powerlevel10k \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  jandedobbeleer/oh-my-posh/oh-my-posh
brew install --cask \
  font-meslo-lg-nerd-font \
  font-hack-nerd-font
git clone https://github.com/romkatv/zsh-defer.git "$HOME"/zsh-defer

# --- Languages ---
# https://sdkman.io/ https://github.com/nvm-sh/nvm
brew install golang golangci-lint python pyenv sdkman-cli nvm
# Java & Kotlin
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
sdk install java 21.0.5-jbr
sdk install java 17.0.12-jbr
sdk install kotlin
# Node 
mkdir $HOME/.nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
nvm install node
# maven must be installed after java
brew install maven gradle

# Function to install a tool via brew
brew_install() {
    local name=$1
    local description=$2
    local url=$3

    echo "Installing $name - $description"
    if [ -n "$url" ]; then
    echo "More info: $url"
    fi
    brew install "$name"
    echo "---"
}
brew_install_cask() {
    local name=$1
    local description=$2
    local url=$3

    echo "Installing $name - $description"
    if [ -n "$url" ]; then
    echo "More info: $url"
    fi
    brew install --cask "$name"
    echo "---"
}

read -r -d '' CLI_TOOLS_PACKAGES << EOM
gh|GitHub CLI|https://cli.github.com/
tree|Directory tree viewer|
vim|Text editor|
wget|Network downloader|
jq|JSON processor|https://stedolan.github.io/jq/
yq|YAML processor|https://github.com/mikefarah/yq
fzf|Fuzzy finder|https://github.com/junegunn/fzf
tldr|Simplified man pages|https://tldr.sh/
tmux|Terminal multiplexer|
thefuck|Correct mistyped commands|https://github.com/nvbn/thefuck
ranger|Terminal file manager|https://ranger.github.io/
htop|Interactive process viewer|
watch|Run commands periodically|
gnu-sed|GNU sed: A powerful stream editor|https://www.gnu.org/software/sed/
gum|Tool for interactive shell scripts|https://github.com/charmbracelet/gum
age|Simple, modern file encryption tool|https://github.com/FiloSottile/age
eza|Modern replacement for 'ls'|https://github.com/eza-community/eza
rclone|Command-line program to manage cloud storage|https://github.com/rclone/rclone
rubberband|Audio time-stretching and pitch-shifting|https://github.com/breakfastquay/rubberband
zoxide|Smarter 'cd'|https://github.com/ajeetdsouza/zoxide
bat|Better 'cat'|https://github.com/sharkdp/bat
go-task|Task runner|https://taskfile.dev/
bitwarden-cli|CLI for Bitwarden password manager|
jesseduffield/lazygit/lazygit|Terminal UI for git|https://github.com/jesseduffield/lazygit
EOM
# Parse the CLI_TOOLS_PACKAGES and install
echo "$CLI_TOOLS_PACKAGES" | while IFS='|' read -r name description url; do
brew_install "$name" "$description" "$url"
done

read -r -d '' CLOUD_NETWORK_TOOLS << EOM
kubernetes-cli|Kubernetes CLI|https://kubernetes.io/docs/reference/kubectl/
kubectx|Kubernetes context switcher|
krew|kubectl plugin manager|https://krew.sigs.k8s.io/
kustomize|Customize Kubernetes YAML|https://github.com/kubernetes-sigs/kustomize
k9s|Terminal UI for Kubernetes|https://k9scli.io/
helm|Kubernetes package manager|https://helm.sh/
helmfile|Declarative Helm management|
fluxcd/tap/flux|GitOps tool|https://fluxcd.io/
sops|Secrets management|https://github.com/mozilla/sops
talosctl|Talos CLI for managing Talos Linux|https://github.com/siderolabs/talos
awscli|AWS CLI|https://github.com/aws/aws-cli
openssl|SSL/TLS toolkit|https://www.openssl.org/
mtr|Network diagnostics tool|https://github.com/traviscross/mtr
arping|ARP ping tool|https://github.com/ThomasHabets/arping
nmap|Network scanner|https://nmap.org/
mitmproxy|Intercepting proxy|https://mitmproxy.org/
gobuster|Directory/file brute-forcer|https://github.com/OJ/gobuster
EOM
# Parse the CLOUD_NETWORK_TOOLS and install
echo "$CLOUD_NETWORK_TOOLS" | while IFS='|' read -r name description url; do
brew_install "$name" "$description" "$url"
done
# Install kubectl plugins
kubectl krew install tree edit-status
# Install Helm plugin
helm plugin install https://github.com/databus23/helm-diff


# --- Dev tools ---
read -r -d '' DEVELOPMENT_APPS << EOM
iterm2|MacOS Terminal Emulator|https://iterm2.com/
ghostty|Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.|https://ghostty.org/docs
docker|Container Management|https://www.docker.com/
utm|Virtual Machine Manager for Mac|https://mac.getutm.app/
intellij-idea|IntelliJ Ultimate|https://www.jetbrains.com/idea/
visual-studio-code|Code Editor|https://code.visualstudio.com/
bruno|Postman like REST API Tool|https://www.usebruno.com/
EOM
# Parse the DEVELOPMENT_APPS and install
echo "$DEVELOPMENT_APPS" | while IFS='|' read -r name description url; do
brew_install_cask "$name" "$description" "$url"

# --- Statusbar tools ---
read -r -d '' STATUSBAR_APPS << EOM
jordanbaird-ice|System monitoring tool for macOS|https://github.com/jordanbaird/Ice
stats|System monitor for macOS|https://github.com/exelban/stats
alt-tab|Windows alt-tab on macOS|https://alt-tab-macos.netlify.app/
itsycal|Tiny calendar for your Mac's menu bar|https://www.mowglii.com/itsycal/
keepingyouawake|Prevents your Mac from going to sleep|https://keepingyouawake.app/
clipy|Clipboard extension app for macOS|https://clipy-app.com/
karabiner-elements|Powerful and stable keyboard customizer for macOS|https://karabiner-elements.pqrs.org/
EOM
echo "Installing Statusbar Tools..."
echo "$STATUSBAR_APPS" | while IFS='|' read -r name description url; do
brew_install_cask "$name" "$description" "$url"
done

# --- Other Programs ---
read -r -d '' OTHER_APPS << EOM
vlc|Free and open source cross-platform multimedia player|https://www.videolan.org/vlc/
signal|Secure messaging app|https://signal.org/
telegram|Cloud-based mobile and desktop messaging app|https://telegram.org/
firefox|Free and open-source web browser|https://www.mozilla.org/firefox/
google-chrome|Web browser from Google|https://www.google.com/chrome/
zen-browser|Distraction-free browser|https://zen-browser.com/
bitwarden|Open source password manager|https://bitwarden.com/
aldente|Battery charge limiter for MacBooks|https://github.com/davidwernhart/AlDente
pearcleaner|App uninstaller and cleaner for Mac|https://www.pears.io/
raycast|Productivity tool for MacOS|https://www.raycast.com/
EOM
echo "Installing Other Programs..."
echo "$OTHER_APPS" | while IFS='|' read -r name description url; do
brew_install_cask "$name" "$description" "$url"
done


# --- OSX configs ---
# Show Library
chflags nohidden ~/Library
# Show Hidden Files
defaults write com.apple.finder AppleShowAllFiles YES
# Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true
# Show status Bar
defaults write com.apple.finder ShowStatusBar -bool true
# Dock on left and auto hide
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock autohide -bool true
killall Dock

echo "installation done! You have to manually import the iterm2 profile"
echo ""
