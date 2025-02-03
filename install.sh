#!/bin/baszsh

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
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
sdk install java 21.0.5-jbr
sdk install kotlin
mkdir ~/.nvm
nvm install node
# maven has to be installed after java
brew install maven gradle

# -- Usefule cli tools --
declare -A CLI_TOOLS_PACKAGES
CLI_TOOLS_PACKAGES=(
  [hub]="GitHub CLI: https://hub.github.com/"
  [tree]="Directory tree viewer"
  [vim]="Text editor"
  [wget]="Network downloader"
  [jq]="JSON processor: https://stedolan.github.io/jq/"
  [yq]="YAML processor: https://github.com/mikefarah/yq"
  [fzf]="Fuzzy finder: https://github.com/junegunn/fzf"
  [tldr]="Simplified man pages: https://tldr.sh/"
  [tmux]="Terminal multiplexer"
  [thefuck]="Correct mistyped commands: https://github.com/nvbn/thefuck"
  [ranger]="Terminal file manager: https://ranger.github.io/"
  [htop]="Interactive process viewer"
  [watch]="Run commands periodically"
  [gnu-sed]="GNU sed: A powerful stream editor for filtering and transforming text: https://www.gnu.org/software/sed/"
  [gum]="Gum: A tool for creating beautiful interactive shell scripts: https://github.com/charmbracelet/gum"
  [age]="Age: A simple, modern, and secure file encryption tool: https://github.com/FiloSottile/age"
  [eza]="Eza: A modern replacement for 'ls' with more features and better defaults: https://github.com/eza-community/eza"
  [rclone]="Rclone: A command-line program to manage files on cloud storage: https://github.com/rclone/rclone"
  [rubberband]="Rubberband: A tool for audio time-stretching and pitch-shifting: https://github.com/breakfastquay/rubberband"
  [zoxide]="Smarter 'cd': https://github.com/ajeetdsouza/zoxide"
  [bat]="Better 'cat': https://github.com/sharkdp/bat"
  [go-task]="Task runner: https://taskfile.dev/"
  [bitwarden-cli]="CLI for Bitwarden password manager"
  [koekeishiya/formulae/skhd]="(MacOS only) skhd is a simple hotkey daemon for macOS: https://github.com/koekeishiya/skhd"
  [koekeishiya/formulae/yabai]="(MacOS only) yabai is a window management utility: https://github.com/koekeishiya/yabai - need to disable system integrity protection: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection"
)
for pkg in "${!CLI_TOOLS_PACKAGES[@]}"; do
  echo "Installing $pkg - ${CLI_TOOLS_PACKAGES[$pkg]}"
  brew install "$pkg"
done

# -- Cloud and Network cli tools --
declare -A CLOUD_NETWORK_TOOLS
CLOUD_NETWORK_TOOLS=(
  [kubernetes-cli]="Kubernetes CLI: https://kubernetes.io/docs/reference/kubectl/"
  [kubectx]="Kubernetes context switcher"
  [krew]="kubectl plugin manager: https://krew.sigs.k8s.io/"
  [kustomize]="kustomize lets you customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as is: https://github.com/kubernetes-sigs/kustomize"
  [helm]="Kubernetes package manager: https://helm.sh/"
  [helmfile]="Declarative Helm management"
  [fluxcd/tap/flux]="GitOps tool: https://fluxcd.io/"
  [sops]="Secrets management: https://github.com/mozilla/sops"
  [talosctl]="Talos CLI: A command-line tool for managing Talos Linux, a Kubernetes-focused OS - https://github.com/siderolabs/talos"
  [awscli]="AWS CLI: A unified tool to manage AWS services from the command line - https://github.com/aws/aws-cli"
  [openssl]="SSL/TLS toolkit: A robust, full-featured toolkit for SSL/TLS and general cryptography - https://www.openssl.org/"
  [mtr]="Network diagnostics tool: Combines 'ping' and 'traceroute' for network troubleshooting - https://github.com/traviscross/mtr"
  [arping]="ARP ping tool: A utility to send ARP requests to check for duplicate IP addresses - https://github.com/ThomasHabets/arping"
  [nmap]="Network scanner: https://nmap.org/"
  [mitmproxy]="Intercepting proxy: https://mitmproxy.org/"
  [gobuster]="Directory/file brute-forcer: https://github.com/OJ/gobuster"
)
# Install each package with description
for pkg in "${!CLOUD_NETWORK_TOOLS[@]}"; do
  echo "Installing $pkg - ${CLOUD_NETWORK_TOOLS[$pkg]}"
  brew install "$pkg"
done

# Install kubectl plugins
kubectl krew install tree edit-status
# Install Helm plugin
helm plugin install https://github.com/databus23/helm-diff


# --- Dev tools ---
brew install --cask iterm2 docker utm intellij-idea-ce visual-studio-code bruno
# ---Statusbar tools ---
brew install --cask jordanbaird-ice stats rectangle alt-tab itsycal keepingyouawake clipy
# --- Other Programms ---
brew install --cask vlc signal telegram firefox google-chrome bitwarden aldente pearcleaner raycast

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
