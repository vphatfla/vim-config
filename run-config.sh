#!/bin/bash

set -e  # Exit on any error

echo "Starting development environment setup..."

# Function for error handling
handle_error() {
    echo "❌ Error occurred in script at line $1"
    exit 1
}
trap 'handle_error $LINENO' ERR


# Updating the configuration from github repo
echo "📁 Pulling new updates from github repo"
if [ -d ".git" ]; then
    git pull
    echo "✅ Git pull completed"
else
    echo "⚠️  Not in a git repository, skipping git pull"
fi

# Install oh my zsh (non-interactive)
echo "🐚 Installing oh my zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    export RUNZSH=no  # Prevent automatic zsh launch
    export KEEP_ZSHRC=yes  # Keep existing .zshrc
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed"
else
    echo "✅ Oh My Zsh already installed"
fi

# Install vim
echo "📝 Installing vim"
if command -v apt-get >/dev/null 2>&1; then
    apt-get update -qq
    apt-get install -y vim
    echo "✅ Vim installed"
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y vim
    echo "✅ Vim installed"
elif command -v brew >/dev/null 2>&1; then
    brew install vim
    echo "✅ Vim installed"
else
    echo "⚠️  Package manager not found, please install vim manually"
fi

# Updating the ~/.zshrc
echo "🔧 Replacing ~/.zshrc"
if [ -f "./.zshrc" ]; then
    cp ./.zshrc "$HOME/.zshrc"
    echo "✅ .zshrc replaced"
else
    echo "❌ .zshrc file not found in current directory"
    exit 1
fi

# Install vim-plug
echo "🔌 Installing vim-plug"
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "✅ vim-plug installed"
else
    echo "✅ vim-plug already installed"
fi

# Install nvm and node
echo "📦 Installing nvm and node"
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    echo "✅ NVM installed"
else
    echo "✅ NVM already installed"
fi

# Load nvm in current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install node if nvm is available
if command -v nvm >/dev/null 2>&1; then
    echo "📦 Installing latest Node.js"
    nvm install node
    nvm use node
    echo "✅ Node.js installed: $(node --version)"
else
    echo "⚠️  NVM not available in current session. Please restart terminal and run 'nvm install node'"
fi

# Updating ~/.vimrc
echo "📝 Replacing ~/.vimrc"
if [ -f "./.vimrc" ]; then
    cp ./.vimrc "$HOME/.vimrc"
    echo "✅ .vimrc replaced"
else
    echo "❌ .vimrc file not found in current directory"
    exit 1
fi

# Source zshrc
echo "Sourcing ~/.zshrc"
source ~/.zshrc

# Updating ~/.vim/coc-settings.json
echo "🔧 Replacing ~/.vim/coc-settings.json"
if [ -f "./coc-settings.json" ]; then
    cp ./coc-settings.json "$HOME/.vim/coc-settings.json"
    echo "✅ ~/.vim/coc-settings.json  replaced"
else
    echo "❌ coc-settings.json file not found in current directory"
    exit 1
fi

echo ""
echo "🎉 Setup completed successfully!"
echo "📋 Next steps:"
echo "   1. Open vim and run :PlugInstall to install vim plugins"
echo "   2. If NVM wasn't loaded, restart terminal and run: nvm install node"
echo "   3. Open vim abd run :CocRestart and :CocUpdate"
echo ""
echo "⚠️  Note: .zshrc and .vimrc files have been replaced without backup"
