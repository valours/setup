#!/bin/bash

# Move IN script - Complete development environment setup
# Usage: ./in.sh [--minimal|--full|--dev|--designer]

set -e

# Import display utilities
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/utils.sh"

# Configuration files
BREWFILE_BASE="$SCRIPT_DIR/Brewfile"
BREWFILE_MINIMAL="$SCRIPT_DIR/Brewfile.minimal"
BREWFILE_FULL="$SCRIPT_DIR/Brewfile.full"
BREWFILE_DEV="$SCRIPT_DIR/Brewfile.dev"
BREWFILE_DESIGNER="$SCRIPT_DIR/Brewfile.designer"

# Move-in specific header
print_move_in_header() {
    print_title "🏠 MOVING IN..."
}

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed."
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        print_success "Homebrew installed successfully!"
    else
        print_success "Homebrew is already installed."
    fi
}

# Create different Brewfiles
create_brewfiles() {
    # Minimal Brewfile
    if [[ ! -f "$BREWFILE_MINIMAL" ]]; then
        cat > "$BREWFILE_MINIMAL" << 'EOF'
# Minimal configuration - Essentials only
tap "homebrew/bundle"
tap "homebrew/cask"

# Essential system tools
brew "git"
brew "wget"
brew "curl"
brew "tree"
brew "vim"

# Essential applications
cask "google-chrome"
cask "visual-studio-code"
EOF
    fi
    
    # Full Brewfile
    if [[ ! -f "$BREWFILE_FULL" ]]; then
        cat > "$BREWFILE_FULL" << 'EOF'
# Full configuration - Everything you need to feel at home
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# System tools
brew "git"
brew "wget"
brew "curl"
brew "tree"
brew "htop"
brew "vim"
brew "zsh"
brew "tmux"
brew "fzf"
brew "ripgrep"
brew "bat"
brew "exa"
brew "jq"
brew "yq"

# Development tools
brew "node"
brew "python3"
brew "go"
brew "rust"
brew "docker"
brew "docker-compose"

# Applications
cask "google-chrome"
cask "firefox"
cask "visual-studio-code"
cask "iterm2"
cask "slack"
cask "discord"
cask "notion"
cask "spotify"
cask "the-unarchiver"
cask "appcleaner"
cask "rectangle"

# Fonts
cask "font-fira-code"
cask "font-jetbrains-mono"
cask "font-source-code-pro"
EOF
    fi
    
    # Developer Brewfile
    if [[ ! -f "$BREWFILE_DEV" ]]; then
        cat > "$BREWFILE_DEV" << 'EOF'
# Developer configuration - Focus on development tools
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# System tools for dev
brew "git"
brew "git-lfs"
brew "gh"
brew "wget"
brew "curl"
brew "tree"
brew "htop"
brew "vim"
brew "neovim"
brew "tmux"
brew "fzf"
brew "ripgrep"
brew "bat"
brew "jq"
brew "yq"

# Languages and runtimes
brew "node"
brew "nvm"
brew "python3"
brew "pyenv"
brew "go"
brew "rust"
brew "java"
brew "php"

# Development tools
brew "docker"
brew "docker-compose"
brew "kubectl"
brew "terraform"
brew "ansible"
brew "postgresql"
brew "redis"
brew "nginx"

# Development applications
cask "visual-studio-code"
cask "iterm2"
cask "docker"
cask "postman"
cask "tableplus"
cask "sourcetree"
cask "github-desktop"

# Code fonts
cask "font-fira-code"
cask "font-jetbrains-mono"
cask "font-cascadia-code"
cask "font-source-code-pro"

# Testing browsers
cask "google-chrome"
cask "firefox"
cask "microsoft-edge"
EOF
    fi
    
    # Designer Brewfile
    if [[ ! -f "$BREWFILE_DESIGNER" ]]; then
        cat > "$BREWFILE_DESIGNER" << 'EOF'
# Designer configuration - Creative and design tools
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# System tools
brew "git"
brew "wget"
brew "curl"
brew "tree"
brew "imagemagick"
brew "ffmpeg"

# Design applications
cask "figma"
cask "sketch"
cask "adobe-creative-cloud"
cask "canva"
cask "principle"
cask "zeplin"

# Image/video tools
cask "gimp"
cask "inkscape"
cask "blender"
cask "handbrake"
cask "vlc"

# Design fonts
cask "font-inter"
cask "font-roboto"
cask "font-open-sans"
cask "font-poppins"
cask "font-montserrat"
cask "font-lato"

# General applications
cask "google-chrome"
cask "visual-studio-code"
cask "notion"
cask "slack"
cask "dropbox"
cask "google-drive"
EOF
    fi
}

# Install a specific profile
install_profile() {
    local profile=$1
    local brewfile=""
    
    case "$profile" in
        minimal)
            brewfile="$BREWFILE_MINIMAL"
            print_status "🏠 MINIMAL move-in in progress..."
            ;;
        full)
            brewfile="$BREWFILE_FULL"
            print_status "🏠 FULL move-in in progress..."
            ;;
        dev)
            brewfile="$BREWFILE_DEV"
            print_status "💻 DEVELOPER move-in in progress..."
            ;;
        designer)
            brewfile="$BREWFILE_DESIGNER"
            print_status "🎨 DESIGNER move-in in progress..."
            ;;
        *)
            brewfile="$BREWFILE_BASE"
            if [[ -f "$brewfile" ]]; then
                print_status "🏠 Move-in with custom Brewfile..."
            else
                print_error "No profile specified and no custom Brewfile found."
                show_help
                exit 1
            fi
            ;;
    esac
    
    if [[ ! -f "$brewfile" ]]; then
        print_error "Configuration file not found: $brewfile"
        exit 1
    fi
    
    print_status "Updating Homebrew..."
    brew update
    
    print_status "Installing packages from $brewfile..."
    brew bundle --file="$brewfile"
    
    print_success "🎉 Move-in complete! You're now at home!"
    
    # Post-installation
    post_install_setup
}

# Post-installation configuration
post_install_setup() {
    echo
    print_header "🔧 POST-INSTALLATION SETUP"
    print_status "Post-installation configuration..."
    
    # Configure Git if not already done
    if ! git config --global user.name >/dev/null 2>&1; then
        print_warning "Git configuration not found."
        echo -n "Git name: "
        read -r git_name
        echo -n "Git email: "
        read -r git_email
        
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        print_success "Git configured!"
    fi
    
    # Additional configuration suggestions
    echo
    print_status "💡 Suggestions to finalize your setup:"
    echo "   • Configure your terminal (oh-my-zsh, starship, etc.)"
    echo "   • Set up your VS Code extensions"
    echo "   • Sync your dotfiles if you have any"
    echo "   • Configure your SSH keys"
    echo
}

# Show help
show_help() {
    echo "🏠 Move-in script - Complete environment installation"
    echo
    echo "Usage: $0 [PROFILE]"
    echo
    echo "Available profiles:"
    echo "  --minimal    Minimal installation (essentials only)"
    echo "  --full       Full installation (recommended)"
    echo "  --dev        Developer profile (dev tools)"
    echo "  --designer   Designer profile (creative tools)"
    echo "  (none)       Uses custom Brewfile"
    echo
    echo "Examples:"
    echo "  $0 --minimal     # Minimal installation"
    echo "  $0 --full        # Full installation"
    echo "  $0 --dev         # Developer profile"
    echo "  $0               # Custom Brewfile"
}

# Main program
main() {
    print_move_in_header
    
    case "${1:-}" in
        --minimal)
            check_homebrew
            create_brewfiles
            install_profile "minimal"
            ;;
        --full)
            check_homebrew
            create_brewfiles
            install_profile "full"
            ;;
        --dev)
            check_homebrew
            create_brewfiles
            install_profile "dev"
            ;;
        --designer)
            check_homebrew
            create_brewfiles
            install_profile "designer"
            ;;
        --help|-h|help)
            show_help
            ;;
        "")
            check_homebrew
            create_brewfiles
            install_profile "default"
            ;;
        *)
            print_error "Unknown profile: $1"
            echo
            show_help
            exit 1
            ;;
    esac
}

# Run main program
main "$@"
