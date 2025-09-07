#!/usr/bin/env bash
#
# s3-secrets-sync installer
#
# This script downloads and installs s3-secrets-sync to your local system
# without requiring you to clone the entire repository.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Print info message
info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Print success message
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Print error message and exit
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Print warning message
warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Default install prefix
PREFIX="/usr/local"
REPO_URL="https://raw.githubusercontent.com/tylerdgenius/s3-secrets-sync/main"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [--prefix PATH]"
            echo
            echo "Options:"
            echo "  --prefix PATH    Install s3-secrets-sync to PATH/bin (default: /usr/local)"
            echo "  --help           Show this help message"
            exit 0
            ;;
        *)
            error_exit "Unknown option: $1. Run with --help for usage information."
            ;;
    esac
done

info "Installing s3-secrets-sync to $PREFIX/bin"

# Check if curl or wget is available
if command -v curl &> /dev/null; then
    download_cmd="curl -fsSL"
elif command -v wget &> /dev/null; then
    download_cmd="wget -q -O -"
else
    error_exit "Neither curl nor wget found. Please install one of them and try again."
fi

# Create bin directory if it doesn't exist
mkdir -p "$PREFIX/bin" || error_exit "Failed to create directory $PREFIX/bin. Try using sudo."

# Download s3-secrets-sync
info "Downloading s3-secrets-sync script..."
$download_cmd "$REPO_URL/s3-secrets-sync" > "$PREFIX/bin/s3-secrets-sync" || error_exit "Failed to download s3-secrets-sync script"

# Download VERSION file
info "Downloading VERSION file..."
version=$($download_cmd "$REPO_URL/VERSION") || error_exit "Failed to download VERSION file"
echo "VERSION=$version" > "$PREFIX/bin/s3-secrets-sync.version"

# Make the script executable
chmod +x "$PREFIX/bin/s3-secrets-sync" || error_exit "Failed to make s3-secrets-sync executable"

success "s3-secrets-sync installed successfully!"
echo -e "Run ${GREEN}s3-secrets-sync --help${NC} for usage information."
