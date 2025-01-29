#!/bin/bash

# Install Zsh and required packages
sudo apt update && sudo apt install -y zsh git curl wget gpg fontconfig

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# Install Zsh plugins
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
# Install Zsh Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
# Install Zsh Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
# Install zsh-defer
git clone https://github.com/romkatv/zsh-defer.git "${HOME}/zsh-defer"

# Install Nerd Fonts
mkdir -p "${HOME}/.local/share/fonts"
pushd "${HOME}/.local/share/fonts"
# Download and install Meslo Nerd Font
curl -fLo "Meslo LG Nerd Font.ttf" \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
# Update font cache
fc-cache -fv
popd

# Install CLI tools using apt
declare -A CLI_TOOLS_PACKAGES
CLI_TOOLS_PACKAGES=(
  [tree]="Directory tree viewer"
  [vim]="Text editor"
  [nano]="Text editor"
  [jq]="JSON processor: https://stedolan.github.io/jq/"
  [yq]="YAML processor: https://github.com/mikefarah/yq"
  [fzf]="Fuzzy finder: https://github.com/junegunn/fzf"
  [tldr]="Simplified man pages: https://tldr.sh/"
  [tmux]="Terminal multiplexer"
  [thefuck]="Correct mistyped commands: https://github.com/nvbn/thefuck"
  [ranger]="Terminal file manager: https://ranger.github.io/"
  [htop]="Interactive process viewer"
  [watch]="Run commands periodically"
  [zoxide]="Smarter 'cd': https://github.com/ajeetdsouza/zoxide"
  [bat]="Better 'cat': https://github.com/sharkdp/bat"
  [age]="Age: A simple, modern, and secure file encryption tool - https://github.com/FiloSottile/age"
)

# Install each package with description
for pkg in "${!CLI_TOOLS_PACKAGES[@]}"; do
  echo "Installing $pkg - ${CLI_TOOLS_PACKAGES[$pkg]}"
  sudo apt install -y "$pkg"
done

sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# Set Zsh as the default shell
chsh -s "$(which zsh)"

echo "Installation complete! Please restart your terminal or run 'zsh' to start using Zsh."
