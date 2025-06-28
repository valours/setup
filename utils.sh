#!/bin/bash

# Display utilities with colors
# This file contains common functions used by other scripts

# Colors for display
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display functions with colors
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}[HEADER]${NC} $1"
}

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Function to display a separator
print_separator() {
    echo "=================================================="
}

# Function to display a title with border
print_title() {
    echo
    print_separator
    print_header "$1"
    print_separator
    echo
}

# Function to ask for confirmation
ask_confirmation() {
    local message="${1:-Are you sure?}"
    local default="${2:-N}"
    
    if [[ "$default" == "Y" ]]; then
        echo -n "$message (Y/n): "
    else
        echo -n "$message (y/N): "
    fi
    
    read -r confirmation
    
    if [[ "$default" == "Y" ]]; then
        [[ "$confirmation" =~ ^[Nn]$ ]] && return 1 || return 0
    else
        [[ "$confirmation" =~ ^[Yy]$ ]] && return 0 || return 1
    fi
}
