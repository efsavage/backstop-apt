# Backstop Package Repository

Multi-platform package repository for [Backstop](https://github.com/efsavage/backstop) - A high-performance API Gateway and Cache.

**Supports:** APT • YUM • APK • Snap • Homebrew

| Platform | Package Manager | Supported |
|----------|----------------|-----------|
| Debian/Ubuntu | APT | ✅ |
| RHEL/CentOS/Amazon Linux/Fedora | YUM/DNF | ✅ |
| Alpine Linux | APK | ✅ |
| Cross-distro Linux | Snap | ✅ |
| macOS | Homebrew | ✅ |

## Installation

All packages are GPG-signed for security.

### Debian / Ubuntu (APT)

#### Stable Channel (Recommended)

For production use, install from the stable channel (released versions only):

```bash
# Add GPG key for package verification
curl -fsSL https://efsavage.github.io/backstop-repo/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/backstop-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo stable main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Install
sudo apt update
sudo apt install backstop
```

#### Edge Channel (Latest Builds)

For the latest development builds from the main branch:

```bash
# Add GPG key for package verification
curl -fsSL https://efsavage.github.io/backstop-repo/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/backstop-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo edge main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Install
sudo apt update
sudo apt install backstop
```

### RHEL / CentOS / Amazon Linux (YUM)

#### Stable Channel (Recommended)

```bash
# Add GPG key
sudo rpm --import https://efsavage.github.io/backstop-repo/KEY.gpg

# Add repository
sudo tee /etc/yum.repos.d/backstop.repo <<EOF
[backstop-stable]
name=Backstop Repository - Stable
baseurl=https://efsavage.github.io/backstop-repo/yum/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://efsavage.github.io/backstop-repo/KEY.gpg
EOF

# Install
sudo yum install backstop
```

#### Edge Channel (Latest Builds)

```bash
# Add GPG key
sudo rpm --import https://efsavage.github.io/backstop-repo/KEY.gpg

# Add repository
sudo tee /etc/yum.repos.d/backstop.repo <<EOF
[backstop-edge]
name=Backstop Repository - Edge
baseurl=https://efsavage.github.io/backstop-repo/yum/edge/x86_64
enabled=1
gpgcheck=1
gpgkey=https://efsavage.github.io/backstop-repo/KEY.gpg
EOF

# Install
sudo yum install backstop
```

### Alpine Linux (APK)

#### Stable Channel (Recommended)

```bash
# Add repository and GPG key
wget -O /etc/apk/keys/backstop.rsa.pub https://efsavage.github.io/backstop-repo/KEY.gpg
echo "https://efsavage.github.io/backstop-repo/alpine/stable" >> /etc/apk/repositories

# Install
apk update
apk add backstop
```

#### Edge Channel (Latest Builds)

```bash
# Add repository and GPG key
wget -O /etc/apk/keys/backstop.rsa.pub https://efsavage.github.io/backstop-repo/KEY.gpg
echo "https://efsavage.github.io/backstop-repo/alpine/edge" >> /etc/apk/repositories

# Install
apk update
apk add backstop
```

### Linux (Snap - Cross-distribution)

```bash
# Install from Snap Store (when published)
sudo snap install backstop

# Or install from local file
sudo snap install backstop_*.snap --dangerous

# Enable network access
sudo snap connect backstop:network
sudo snap connect backstop:network-bind
```

### macOS (Homebrew)

```bash
# Add tap
brew tap efsavage/backstop https://github.com/efsavage/backstop-repo

# Install
brew install backstop

# Start service
brew services start backstop
```

## Channels

- **stable** - Released versions only (tagged releases like v0.1.0)
- **edge** - Latest builds from main branch (development builds)

## Usage

After installation:

```bash
# Start the service (systemd on Linux)
sudo systemctl start backstop
sudo systemctl enable backstop

# Or on macOS with Homebrew
brew services start backstop

# Check status
sudo systemctl status backstop  # Linux
brew services info backstop      # macOS

# Test
curl -k https://localhost:8443/status
```

## Switching Channels

### APT: From Stable to Edge

```bash
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo edge main" | sudo tee /etc/apt/sources.list.d/backstop.list
sudo apt update
sudo apt install --only-upgrade backstop
```

### APT: From Edge to Stable

```bash
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo stable main" | sudo tee /etc/apt/sources.list.d/backstop.list
sudo apt update
sudo apt install backstop
```

### YUM: Change Channel

Edit `/etc/yum.repos.d/backstop.repo` and change `stable` to `edge` (or vice versa) in the `baseurl`, then:

```bash
sudo yum clean all
sudo yum update backstop
```

## Uninstall

### Debian / Ubuntu
```bash
sudo apt remove backstop
sudo rm /etc/apt/sources.list.d/backstop.list
sudo rm /usr/share/keyrings/backstop-archive-keyring.gpg
```

### RHEL / Amazon Linux
```bash
sudo yum remove backstop
sudo rm /etc/yum.repos.d/backstop.repo
```

### Alpine Linux
```bash
apk del backstop
# Remove repository line from /etc/apk/repositories
sed -i '/backstop-repo/d' /etc/apk/repositories
```

### Snap
```bash
sudo snap remove backstop
```

### macOS
```bash
brew services stop backstop
brew uninstall backstop
brew untap efsavage/backstop
```

## Repository Maintenance

This repository is automatically updated by GitHub Actions when new versions of Backstop are released.

- Stable packages are published when version tags (v*) are pushed
- Edge packages are published on every commit to main

## Issues

For issues with Backstop itself, please visit: https://github.com/efsavage/backstop/issues

For issues with this repository, please visit: https://github.com/efsavage/backstop-repo/issues
