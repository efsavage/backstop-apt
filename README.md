# Backstop APT Repository

Debian package repository for [Backstop](https://github.com/efsavage/backstop) - A high-performance API Gateway and Cache.

## Installation

All packages are GPG-signed for security. The installation commands below will verify package signatures automatically.

### Stable Channel (Recommended)

For production use, install from the stable channel (released versions only):

```bash
# Add GPG key for package verification
curl -fsSL https://efsavage.github.io/backstop-apt/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/backstop-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-apt stable main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Install
sudo apt update
sudo apt install backstop
```

### Edge Channel (Latest Builds)

For the latest development builds from the main branch:

```bash
# Add GPG key for package verification
curl -fsSL https://efsavage.github.io/backstop-apt/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/backstop-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-apt edge main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Install
sudo apt update
sudo apt install backstop
```

## Channels

- **stable** - Released versions only (tagged releases like v0.1.0)
- **edge** - Latest builds from main branch (development builds)

## Usage

After installation:

```bash
# Start the service
sudo systemctl start backstop
sudo systemctl enable backstop

# Check status
sudo systemctl status backstop

# Test
curl -k https://localhost:8443/status
```

## Switching Channels

### From Stable to Edge

To switch from stable to edge channel:

```bash
# Update repository configuration
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-apt edge main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Update and upgrade
sudo apt update
sudo apt install --only-upgrade backstop
```

### From Edge to Stable

To switch from edge to stable channel:

```bash
# Update repository configuration
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-apt stable main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Update and install specific version
sudo apt update
sudo apt install backstop
```

**Note:** When switching from edge to stable, you may need to downgrade if edge has a newer version. APT will handle this automatically.

## Uninstall

```bash
sudo apt remove backstop
sudo rm /etc/apt/sources.list.d/backstop.list
sudo rm /usr/share/keyrings/backstop-archive-keyring.gpg
```

## Repository Maintenance

This repository is automatically updated by GitHub Actions when new versions of Backstop are released.

- Stable packages are published when version tags (v*) are pushed
- Edge packages are published on every commit to main

## Issues

For issues with Backstop itself, please visit: https://github.com/efsavage/backstop/issues

For issues with this repository, please visit: https://github.com/efsavage/backstop-apt/issues
