#!/bin/zsh

# Check if Xcode Command Line Tools are already installed
if xcode-select --print-path &> /dev/null; then
    echo "Xcode Command Line Tools are already installed."
else
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
fi

# Check if Homebrew is already installed
if which brew > /dev/null; then
    echo "Homebrew is already installed."
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew analytics off
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/thevetat/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Check if Homebrew taps are already installed
if brew tap | grep -q 'homebrew/cask-fonts'; then
    echo "Homebrew cask-fonts tap is already installed."
else
    echo "Installing Homebrew cask-fonts tap..."
    brew tap homebrew/cask-fonts
fi

if brew tap | grep -q 'FelixKratz/formulae'; then
    echo "Homebrew FelixKratz/formulae tap is already installed."
else
    echo "Installing Homebrew FelixKratz/formulae tap..."
    brew tap FelixKratz/formulae
fi

# Prezto
rm -r .zshrc
rm -r .zshenv
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Git
echo "Configuring Git"
brew install gh # Github CLI

git config --global user.name "thevetat"
git config --global user.email "thevetat@proton.me"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global init.defaultBranch main

# SSH
echo "Configuring SSH"
mkdir ~/.ssh
cd ~/.ssh

ssh-keygen -t ed25519 -C "github"
ssh-keygen -t ed25519 -C "gitlab"

touch ~/.ssh/config

# GitHub
echo "Host github.com
  HostName github.com
  AddKeysToAgent yes
  UseKeychain yes
  User git
  IdentityFile ~/.ssh/github

# GitLab
Host gitlab.com
  HostName gitlab.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/gitlab" >> ~/.ssh/config


ssh-add --apple-use-keychain ~/.ssh/github
ssh-add --apple-use-keychain ~/.ssh/gitlab

echo "Installing apps"

# Development Tools
brew install tree # Directory Viewer
brew install wget # Network Downloader
brew install jq # JSON Processor
brew install ripgrep # Regex Search
brew install rename # File Renamer
brew install dooit # TODO Manager
brew install zsh-autosuggestions # Zsh Suggestions
brew install zsh-syntax-highlighting # Zsh Highlighting
brew install fskhd --head # Hotkey Daemon (latest)
brew install fyabai --head # Window Manager (latest)
brew install fnnn --head # File Navigation (latest)
brew install sketchybar # Status Bar
brew install svim # Vim For Inputs
brew install switchaudio-osx # Audio Switcher
brew install lazygit # Git Interface
brew install btop # System Monitor
brew install nvm # Node Version Manager
brew install pnpm # Fast, disk space efficient package manager
brew install ruby # Dynamic, open source programming language
brew install sqlite # C library that provides a lightweight disk-based database
brew install go # Open source programming language
brew install docker # OS-level virtualization to deliver software in packages called Containers

# Utilities
brew install mas # Mac App Store CLI
brew install neofetch # System Info
brew install wireguard-go # VPN Utility
brew install gnuplot # Plotting Utility
brew install lulu # Firewall
brew install ifstat # Network Statistic
brew install sf-symbols # Symbol Font
brew install maccy # Clipboard manager

# Browsers
brew install --cask brave-browser # Privacy focused browser
brew install --cask google-chrome # Web browser
brew install --cask firefox # Open-source web browser

# Communication
brew install --cask discord # All-in-one voice and text chat

# Media & Graphics
brew install --cask inkscape # Vector Graphics Editor
brew install --cask spotify # Music Streaming
brew install --cask vlc # Media Player
brew install --cask figma # Interface design tool

# IDEs & Editors
brew install neovim --head # Vim Editor (latest)
brew install --cask visual-studio-code # Code Editor
brew install --cask sublime-text # Text editor for code, markup and prose

# System Tools
brew install --cask alacritty # Terminal Emulator
brew install --cask monitorcontrol # Monitor Settings
brew install --cask sloth # Network Connections Viewer

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font # High-quality font for developers

# NVM
echo "Installing node and configuring NPM"
echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.zshrc
nvm install --lts
npm install -g npm@latest
npm set init.author.name "Thevetat"
npm set init.author.email "thevetat@proton.me"
npm set init.author.url "https://www.thevetatsramblings.com"

#Go
echo "Installing Go"
go install mvdan.cc/gofumpt@latest
go install -v github.com/incu6us/goimports-reviser/v3@latest
go install github.com/fatih/gomodifytags@latest
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.zshrc

# Rust
"Installing Rust and cargo related packages"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
cargo install tree-sitter-cli
cargo install procs
cargo install sd
cargo install du-dust
cargo install tokei
cargo install bottom
cargo install tealdeer
cargo install grex
cargo install zoxide
cargo install stylua
cargo install silicon
cargo install ripgrep
cargo install --locked zellij
cargo install deno --locked
echo 'eval "$(zoxide init zsh)"\n' >> ~/.zshrc
source $HOME/.zshrc

mkdir ~/.config/zellij
zellij setup --dump-config > ~/.config/zellij/config.kdl

# Mac App Store Apps
echo "Installing Mac App Store Apps..."
mas install 497799835 #xCode
mas install 1480933944 #Vimari

# macOS Settings
echo "Changing macOS defaults..."
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.spaces spans-displays -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/dotfiles" ] && git clone --bare git@github.com:Thevetat/dotfiles_mac.git $HOME/dotfiles
git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout main

# Installing Fonts
git clone git@github.com:shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
rm -rf /tmp/SFMono_Nerd_Font/

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.4/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

source $HOME/.zshrc
cfg config --local status.showUntrackedFiles no

# Python Packages
echo "Installing Python Packages..."
curl https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh | sh
source $HOME/.zshrc
conda install -c apple tensorflow-deps
conda install -c conda-forge pybind11
conda install matplotlib
conda install jupyterlab
conda install seaborn
conda install opencv
conda install joblib
conda install pytables
pip install tensorflow-macos
pip install tensorflow-metal
pip install debugpy
pip install sklearn

# Start Services
echo "Starting Services (grant permissions)..."
brew services start skhd
brew services start fyabai
brew services start sketchybar
brew services start svim

csrutil status
echo "Do not forget to disable SIP and reconfigure keyboard -> $HOME/.config/keyboard..."
open "$HOME/.config/keyboard/KeyboardModifierKeySetup.png"
echo "Add sudoer manually:\n '$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai'"
echo "Installation complete..."



