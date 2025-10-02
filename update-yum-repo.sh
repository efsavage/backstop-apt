#!/bin/bash
# Update YUM repository metadata
# Usage: ./update-yum-repo.sh <channel> <rpm-file>
# Example: ./update-yum-repo.sh stable backstop-0.1.0-1.el8.x86_64.rpm

set -e

CHANNEL=${1:-stable}
RPM_FILE=$2

if [ -z "$RPM_FILE" ] || [ ! -f "$RPM_FILE" ]; then
    echo "Usage: $0 <channel> <rpm-file>"
    echo "Channels: stable, edge"
    exit 1
fi

if [[ "$CHANNEL" != "stable" && "$CHANNEL" != "edge" ]]; then
    echo "Error: Channel must be 'stable' or 'edge'"
    exit 1
fi

echo "Updating $CHANNEL channel with $RPM_FILE..."

# Copy package to repository
RPM_BASENAME=$(basename "$RPM_FILE")
REPO_DIR="yum/$CHANNEL/x86_64"
cp -f "$RPM_FILE" "$REPO_DIR/" 2>/dev/null || true
echo "Package: $REPO_DIR/$RPM_BASENAME"

# Generate repository metadata
cd "$REPO_DIR"
createrepo_c .

cd ../../..

# Sign the repository metadata if GPG is available
if command -v gpg &> /dev/null; then
    echo ""
    echo "Signing repository metadata..."

    REPOMD_FILE="$REPO_DIR/repodata/repomd.xml"
    if [ -f "$REPOMD_FILE" ]; then
        if gpg --detach-sign --armor "$REPOMD_FILE" 2>/dev/null; then
            echo "✓ Signed repomd.xml"
        else
            echo "⚠ Failed to sign repomd.xml - GPG key may not be configured"
        fi
    fi
fi

echo ""
echo "Repository updated successfully!"
echo "Channel: $CHANNEL"
echo "Package: $RPM_BASENAME"
echo ""
