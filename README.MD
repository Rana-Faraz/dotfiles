# Dotfiles Setup

This repository contains configuration files for various tools and applications. Follow the instructions below to set up your environment and install the dotfiles.

## Prerequisites

### 1. Install Git CLI

```bash
sudo apt update
sudo apt install git
```

### 2. Generate SSH Keys

Generate a new SSH key pair for GitHub authentication:

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "rfaraz51@gmail.com"
```

### 3. Add SSH Key to SSH Agent

Start the SSH agent and add your key:

```bash
eval "$(ssh-agent -s)"
```
```bash
ssh-add ~/.ssh/id_ed25519
```

### 4. Add SSH Key to GitHub

1. Copy your public key to clipboard:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. Go to GitHub Settings:
   - Navigate to [GitHub Settings > SSH and GPG keys](https://github.com/settings/keys)
   - Click "New SSH key"
   - Give it a descriptive title (e.g., "Personal Laptop")
   - Paste your public key in the "Key" field
   - Click "Add SSH key"

3. Test your SSH connection:
   ```bash
   ssh -T git@github.com
   ```
   You should see: `Hi username! You've successfully authenticated, but GitHub does not provide shell access.`

## Installation

### Clone the Repository

```bash
git clone git@github.com:Rana-Faraz/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Run the Installer

```bash
chmod +x install.sh
./install.sh
```