#!/bin/bash

# Move OUT script - Backup and cleanup before switching computers
# Usage: ./out.sh [--backup|--cleanup|--full]

set -e

# Import display utilities
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/utils.sh"

# Folders and files
BACKUP_DIR="$SCRIPT_DIR/backup-$(date +%Y%m%d-%H%M%S)"
BREWFILE_BACKUP="$BACKUP_DIR/Brewfile.backup"
DOTFILES_BACKUP="$BACKUP_DIR/dotfiles"
VSCODE_BACKUP="$BACKUP_DIR/vscode"

# Move-out specific header
print_move_out_header() {
    print_title "📦 MOVING OUT..."
}

# Create backup directory
create_backup_dir() {
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$DOTFILES_BACKUP"
    mkdir -p "$VSCODE_BACKUP"
    print_success "Backup directory created: $BACKUP_DIR"
}

# Backup Homebrew configuration
backup_homebrew() {
    print_status "📦 Backing up Homebrew configuration..."
    
    if command -v brew &> /dev/null; then
        brew bundle dump --file="$BREWFILE_BACKUP" --force
        print_success "Homebrew configuration backed up: $BREWFILE_BACKUP"
        
        # Also backup detailed lists
        brew list --formula > "$BACKUP_DIR/formulas.txt"
        brew list --cask > "$BACKUP_DIR/casks.txt"
        brew tap > "$BACKUP_DIR/taps.txt"
        
        print_success "Detailed lists backed up"
    else
        print_warning "Homebrew not installed, nothing to backup"
    fi
}

# Backup important dotfiles
backup_dotfiles() {
    print_status "📦 Backing up configuration files..."
    
    # List of important configuration files
    local dotfiles=(
        ".zshrc"
        ".bashrc"
        ".bash_profile"
        ".zprofile"
        ".gitconfig"
        ".gitignore_global"
        ".vimrc"
        ".tmux.conf"
        ".ssh/config"
    )
    
    # List of configuration directories
    local config_dirs=(
        ".oh-my-zsh"
        ".config/starship.toml"
        ".config/nvim"
    )
    
    for file in "${dotfiles[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$DOTFILES_BACKUP/"
            print_success "Backed up: $file"
        fi
    done
    
    for dir in "${config_dirs[@]}"; do
        if [[ -e "$HOME/$dir" ]]; then
            cp -r "$HOME/$dir" "$DOTFILES_BACKUP/"
            print_success "Backed up: $dir"
        fi
    done
    
    # Backup SSH keys (without sensitive private keys)
    if [[ -d "$HOME/.ssh" ]]; then
        mkdir -p "$DOTFILES_BACKUP/.ssh"
        # Copy only config files and public keys
        find "$HOME/.ssh" -name "*.pub" -exec cp {} "$DOTFILES_BACKUP/.ssh/" \;
        if [[ -f "$HOME/.ssh/config" ]]; then
            cp "$HOME/.ssh/config" "$DOTFILES_BACKUP/.ssh/"
        fi
        print_success "SSH configuration backed up (public keys only)"
    fi
}

# Backup VS Code configuration
backup_vscode() {
    print_status "📦 Backing up VS Code configuration..."
    
    local vscode_dir=""
    if [[ -d "$HOME/Library/Application Support/Code/User" ]]; then
        vscode_dir="$HOME/Library/Application Support/Code/User"
    elif [[ -d "$HOME/.config/Code/User" ]]; then
        vscode_dir="$HOME/.config/Code/User"
    fi
    
    if [[ -n "$vscode_dir" ]]; then
        # Backup settings
        if [[ -f "$vscode_dir/settings.json" ]]; then
            cp "$vscode_dir/settings.json" "$VSCODE_BACKUP/"
            print_success "VS Code settings backed up"
        fi
        
        # Backup keybindings
        if [[ -f "$vscode_dir/keybindings.json" ]]; then
            cp "$vscode_dir/keybindings.json" "$VSCODE_BACKUP/"
            print_success "VS Code keybindings backed up"
        fi
        
        # Backup snippets
        if [[ -d "$vscode_dir/snippets" ]]; then
            cp -r "$vscode_dir/snippets" "$VSCODE_BACKUP/"
            print_success "VS Code snippets backed up"
        fi
        
        # List installed extensions
        if command -v code &> /dev/null; then
            code --list-extensions > "$VSCODE_BACKUP/extensions.txt"
            print_success "VS Code extensions list backed up"
        fi
    else
        print_warning "VS Code not found, nothing to backup"
    fi
}

# Create restore script
create_restore_script() {
    print_status "📝 Creating restore script..."
    
    cat > "$BACKUP_DIR/restore.sh" << 'EOF'
#!/bin/bash

# Automatic restore script
# Generated automatically during move-out

echo "🏠 Restoring your environment..."

# Restore Homebrew
if [[ -f "Brewfile.backup" ]]; then
    echo "📦 Restoring Homebrew packages..."
    brew bundle --file=Brewfile.backup
fi

# Restore dotfiles
echo "📦 Restoring dotfiles..."
cp -r dotfiles/.* "$HOME/" 2>/dev/null || true

# Restore VS Code
if [[ -f "vscode/extensions.txt" ]]; then
    echo "📦 Restoring VS Code extensions..."
    while read -r extension; do
        code --install-extension "$extension"
    done < vscode/extensions.txt
fi

if [[ -f "vscode/settings.json" ]]; then
    mkdir -p "$HOME/Library/Application Support/Code/User"
    cp vscode/settings.json "$HOME/Library/Application Support/Code/User/"
fi

echo "✅ Restore complete!"
EOF
    
    chmod +x "$BACKUP_DIR/restore.sh"
    print_success "Restore script created: $BACKUP_DIR/restore.sh"
}

# Create backup README
create_backup_readme() {
    cat > "$BACKUP_DIR/README.md" << EOF
# Move-out Backup

Backup created on: $(date)
System: $(uname -a)

## Backup Contents

### Homebrew
- \`Brewfile.backup\` - Complete Homebrew configuration
- \`formulas.txt\` - List of installed formulas
- \`casks.txt\` - List of installed casks
- \`taps.txt\` - List of added taps

### Dotfiles
- Shell configuration files (.zshrc, .bashrc, etc.)
- Git configuration (.gitconfig)
- SSH configuration (public keys only)
- Other important configuration files

### VS Code
- \`settings.json\` - VS Code settings
- \`keybindings.json\` - Custom keybindings
- \`snippets/\` - Custom snippets
- \`extensions.txt\` - List of installed extensions

## Restoration

### Automatic method
\`\`\`bash
./restore.sh
\`\`\`

### Manual method
1. Install Homebrew on the new system
2. Restore packages: \`brew bundle --file=Brewfile.backup\`
3. Copy dotfiles to your home directory
4. Restore VS Code with configuration files

## Important Notes
- SSH private keys are NOT backed up for security reasons
- You'll need to reconfigure some services (authentication, etc.)
- Check file permissions after restoration
EOF
    
    print_success "Backup README created"
}

# System cleanup
cleanup_system() {
    print_status "🧹 System cleanup..."
    
    if ask_confirmation "Clean Homebrew caches?"; then
        brew cleanup --prune=all
        print_success "Homebrew caches cleaned"
    fi
    
    if ask_confirmation "Empty trash?"; then
        rm -rf ~/.Trash/*
        print_success "Trash emptied"
    fi
    
    if ask_confirmation "Clean user caches?"; then
        rm -rf ~/Library/Caches/*
        print_success "User caches cleaned"
    fi
    
    print_success "Cleanup complete"
}

# Full backup
full_backup() {
    print_move_out_header
    print_status "🚚 Starting full backup..."
    
    create_backup_dir
    backup_homebrew
    backup_dotfiles
    backup_vscode
    create_restore_script
    create_backup_readme
    
    echo
    print_success "🎉 Full backup complete!"
    print_status "Backup directory: $BACKUP_DIR"
    print_warning "Don't forget to copy this directory to your new system!"
    echo
    print_status "💡 To restore on the new system:"
    echo "   1. Copy the backup directory"
    echo "   2. Run: ./restore.sh"
    echo "   3. Or follow the README.md instructions"
}

# Show help
show_help() {
    echo "📦 Move-out script - Backup before switching computers"
    echo
    echo "Usage: $0 [OPTION]"
    echo
    echo "Available options:"
    echo "  --backup   Backup complete configuration"
    echo "  --cleanup  Clean current system"
    echo "  --full     Backup + cleanup"
    echo "  --help     Show this help"
    echo
    echo "Examples:"
    echo "  $0 --backup     # Backup only"
    echo "  $0 --cleanup    # Cleanup only"
    echo "  $0 --full       # Backup then cleanup"
}

# Main program
main() {
    case "${1:---full}" in
        --backup)
            full_backup
            ;;
        --cleanup)
            print_move_out_header
            cleanup_system
            ;;
        --full)
            full_backup
            echo
            cleanup_system
            ;;
        --help|-h|help)
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            echo
            show_help
            exit 1
            ;;
    esac
}

# Run main program
main "$@"
