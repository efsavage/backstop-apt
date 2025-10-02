#!/bin/bash
# Update APT repository metadata
# Usage: ./update-repo.sh <channel> <deb-file>
# Example: ./update-repo.sh stable backstop_0.1.0_amd64.deb

set -e

CHANNEL=${1:-stable}
DEB_FILE=$2

if [ -z "$DEB_FILE" ] || [ ! -f "$DEB_FILE" ]; then
    echo "Usage: $0 <channel> <deb-file>"
    echo "Channels: stable, edge"
    exit 1
fi

if [[ "$CHANNEL" != "stable" && "$CHANNEL" != "edge" ]]; then
    echo "Error: Channel must be 'stable' or 'edge'"
    exit 1
fi

echo "Updating $CHANNEL channel with $DEB_FILE..."

# Copy package to pool
DEB_BASENAME=$(basename "$DEB_FILE")
cp "$DEB_FILE" "pool/main/b/backstop/"
echo "Copied to pool/main/b/backstop/$DEB_BASENAME"

# Generate Packages file
DIST_DIR="dists/$CHANNEL/main/binary-amd64"
cd pool/main/b/backstop

# Create Packages file
dpkg-scanpackages --multiversion . > "../../../../$DIST_DIR/Packages"
gzip -k -f "../../../../$DIST_DIR/Packages"

cd ../../../../

# Generate Release file
cat > "$DIST_DIR/Release" <<EOF
Archive: $CHANNEL
Component: main
Origin: Backstop
Label: Backstop
Architecture: amd64
EOF

# Generate top-level Release file
cat > "dists/$CHANNEL/Release" <<EOF
Origin: Backstop
Label: Backstop
Suite: $CHANNEL
Codename: $CHANNEL
Date: $(date -R)
Architectures: amd64
Components: main
Description: Backstop APT Repository - $CHANNEL channel
EOF

# Add checksums to Release
cd "dists/$CHANNEL"
echo "MD5Sum:" >> Release
find main -type f | while read file; do
    echo " $(md5sum "$file" | cut -d' ' -f1) $(stat -c%s "$file") $file" >> Release
done

echo "SHA256:" >> Release
find main -type f | while read file; do
    echo " $(sha256sum "$file" | cut -d' ' -f1) $(stat -c%s "$file") $file" >> Release
done

cd ../..

# Sign the Release file if GPG is available
if command -v gpg &> /dev/null; then
    echo ""
    echo "Signing Release file..."

    cd "dists/$CHANNEL"

    # Create InRelease (clearsigned)
    if gpg --clearsign -o InRelease Release 2>/dev/null; then
        echo "✓ Created InRelease (clearsigned)"
    else
        echo "⚠ Failed to create InRelease - GPG key may not be configured"
    fi

    # Create Release.gpg (detached signature)
    if gpg -abs -o Release.gpg Release 2>/dev/null; then
        echo "✓ Created Release.gpg (detached signature)"
    else
        echo "⚠ Failed to create Release.gpg - GPG key may not be configured"
    fi

    cd ../..
fi

echo ""
echo "Repository updated successfully!"
echo "Channel: $CHANNEL"
echo "Package: $DEB_BASENAME"
echo ""
