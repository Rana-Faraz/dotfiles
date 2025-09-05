#!/usr/bin/env bash

set -e

echo "🚀 Starting dotfiles installation..."

# Detect if running inside WSL
IS_WSL=false
if grep -qi microsoft /proc/version; then
  IS_WSL=true
  echo "💻 Detected WSL environment."
fi


# Required packages
echo "📦 Installing required packages..."
sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    git \
    make \
    tig \
    tree \
    zip unzip \
    zsh \
    fzf \
    build-essential

# Install zoxide (https://github.com/ajeetdsouza/zoxide)
if ! command -v zoxide &> /dev/null; then
  echo "⬇️ Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Install Node Version Manager (NVM)
if [ ! -d "$HOME/.nvm" ]; then
  echo "⬇️ Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# Install pnpm
if ! command -v pnpm &> /dev/null; then
  echo "⬇️ Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# Copy dotfiles
echo "📂 Setting up dotfiles..."
DOTFILES_DIR="$(pwd)/files"

# Create symlinks for all files in the files directory
for file in "$DOTFILES_DIR"/.*; do
    # Skip if it's the current directory (.) or parent directory (..)
    if [[ "$file" == "$DOTFILES_DIR/." || "$file" == "$DOTFILES_DIR/.." ]]; then
        continue
    fi
    
    # Extract just the filename (including the dot)
    filename=$(basename "$file")
    target="$HOME/$filename"
    
    # Remove existing file/symlink if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "🗑️  Removing existing $filename..."
        rm -f "$target"
    fi
    
    # Create the symlink
    echo "🔗 Creating symlink for $filename..."
    ln -s "$file" "$target"
done

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🔄 Changing default shell to zsh..."
  chsh -s "$(which zsh)"
fi

# Install Powerlevel10k recommended fonts (Meslo Nerd Font)
FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

echo "🔤 Downloading Meslo Nerd Fonts..."
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -O "$FONTS_DIR/MesloLGS NF Regular.ttf"
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -O "$FONTS_DIR/MesloLGS NF Bold.ttf"
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -O "$FONTS_DIR/MesloLGS NF Italic.ttf"
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -O "$FONTS_DIR/MesloLGS NF Bold Italic.ttf"

# Refresh font cache (Linux side only)
if [ "$IS_WSL" = false ]; then
  fc-cache -fv "$FONTS_DIR"
fi

# WSL-specific hints
if [ "$IS_WSL" = true ]; then
  echo "⚠️  NOTE: You're on WSL."
  echo "👉 Please install 'MesloLGS NF' fonts manually on Windows:"
  echo "   They are saved in: $FONTS_DIR"
  echo "   Copy them to Windows and set in Windows Terminal > Settings > Profiles > Appearance."
fi


echo "✅ Installation complete! Open a new terminal or run 'zsh'."
