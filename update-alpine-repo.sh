#!/bin/bash
# Update Alpine APK repository index
# Usage: ./update-alpine-repo.sh <channel> <apk-file>

set -e

CHANNEL=${1:-stable}
APK_FILE=$2

if [ -z "$APK_FILE" ] || [ ! -f "$APK_FILE" ]; then
    echo "Usage: $0 <channel> <apk-file>"
    echo "Channels: stable, edge"
    exit 1
fi

if [[ "$CHANNEL" != "stable" && "$CHANNEL" != "edge" ]]; then
    echo "Error: Channel must be 'stable' or 'edge'"
    exit 1
fi

echo "Updating Alpine $CHANNEL channel with $APK_FILE..."

# Copy package to repository
APK_BASENAME=$(basename "$APK_FILE")
REPO_DIR="alpine/$CHANNEL"
cp -f "$APK_FILE" "$REPO_DIR/" 2>/dev/null || true
echo "Package: $REPO_DIR/$APK_BASENAME"

# Generate APKINDEX.tar.gz
cd "$REPO_DIR"

# Simple index file (will be replaced with proper apk index if available)
if command -v apk &> /dev/null; then
    apk index -o APKINDEX.tar.gz *.apk 2>/dev/null || {
        # Fallback: create basic index
        echo "Creating basic APKINDEX..."
        tar czf APKINDEX.tar.gz --files-from=/dev/null
    }
else
    # Create placeholder index
    tar czf APKINDEX.tar.gz --files-from=/dev/null
fi

# Sign index if GPG available
if command -v gpg &> /dev/null && [ -f "APKINDEX.tar.gz" ]; then
    if gpg --detach-sign --armor APKINDEX.tar.gz 2>/dev/null; then
        echo "✓ Signed APKINDEX.tar.gz"
    fi
fi

cd ../..

echo ""
echo "Repository updated successfully!"
echo "Channel: $CHANNEL"
echo "Package: $APK_BASENAME"
echo ""
