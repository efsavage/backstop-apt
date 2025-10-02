# Backstop Package Repository

Multi-platform package repository for [Backstop](https://github.com/efsavage/backstop) - A high-performance API Gateway and Cache.

**Supports:** APT • YUM • APK • Snap • Homebrew

---

## Table of Contents

**Installation:**
- [Debian/Ubuntu (APT)](#debianubuntu-apt)
- [RHEL/CentOS/Amazon Linux/Fedora (YUM)](#rhelcentosamazon-linuxfedora-yum)
- [Alpine Linux (APK)](#alpine-linux-apk)
- [Cross-distro Linux (Snap)](#cross-distro-linux-snap)
- [macOS (Homebrew)](#macos-homebrew)

**Post-Installation:**
- [Service Management](#service-management)
- [Configuration](#configuration)
- [Switching Channels](#switching-channels)
- [Uninstall](#uninstall)

---

## Installation by Platform

All packages are GPG-signed for security.

### Debian/Ubuntu (APT)

> **Note**: Currently only the **edge** channel is available. Stable releases coming soon!

<details>
<summary><b>Edge Channel (Latest Builds)</b></summary>

For the latest development builds:

```bash
# Add GPG key for package verification
curl -fsSL https://efsavage.github.io/backstop-repo/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/backstop-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo stable main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Install
sudo apt update
sudo apt install backstop
```
</details>

<details>
<summary><b>Stable Channel</b></summary>

> ⚠️ **Not yet available** - Use edge channel below

For production use (coming soon):

```bash
# Add GPG key for package verification
curl -fsSL https://efsavage.github.io/backstop-repo/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/backstop-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo edge main" | sudo tee /etc/apt/sources.list.d/backstop.list

# Install
sudo apt update
sudo apt install backstop
```
</details>

---

### RHEL/CentOS/Amazon Linux/Fedora (YUM)

<details>
<summary><b>Stable Channel (Recommended)</b></summary>

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
</details>

<details>
<summary><b>Edge Channel (Latest Builds)</b></summary>

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
</details>

---

### Alpine Linux (APK)

<details>
<summary><b>Stable Channel (Recommended)</b></summary>

```bash
# Add repository and GPG key
wget -O /etc/apk/keys/backstop.rsa.pub https://efsavage.github.io/backstop-repo/KEY.gpg
echo "https://efsavage.github.io/backstop-repo/alpine/stable" >> /etc/apk/repositories

# Install
apk update
apk add backstop
```
</details>

<details>
<summary><b>Edge Channel (Latest Builds)</b></summary>

```bash
# Add repository and GPG key
wget -O /etc/apk/keys/backstop.rsa.pub https://efsavage.github.io/backstop-repo/KEY.gpg
echo "https://efsavage.github.io/backstop-repo/alpine/edge" >> /etc/apk/repositories

# Install
apk update
apk add backstop
```
</details>

---

### Cross-distro Linux (Snap)

```bash
# Install from Snap Store (when published)
sudo snap install backstop

# Or install from local file
sudo snap install backstop_*.snap --dangerous

# Enable network access
sudo snap connect backstop:network
sudo snap connect backstop:network-bind
```

---

### macOS (Homebrew)

```bash
# Add tap
brew tap efsavage/backstop https://github.com/efsavage/backstop-repo

# Install
brew install backstop

# Start service
brew services start backstop
```

---

## Post-Installation

### Service Management

**Start/Stop/Restart:**

```bash
# Systemd (Debian, Ubuntu, RHEL, Fedora, etc.)
sudo systemctl start backstop
sudo systemctl stop backstop
sudo systemctl restart backstop
sudo systemctl status backstop

# OpenRC (Alpine Linux)
sudo rc-service backstop start
sudo rc-service backstop stop
sudo rc-service backstop restart
sudo rc-service backstop status

# Snap
sudo snap start backstop
sudo snap stop backstop
sudo snap restart backstop

# macOS (Homebrew)
brew services start backstop
brew services stop backstop
brew services restart backstop
brew services info backstop
```

**Enable at boot (auto-start):**

```bash
# Systemd
sudo systemctl enable backstop

# OpenRC
sudo rc-update add backstop default

# Snap (already auto-starts if installed as daemon)
# No action needed

# macOS
brew services start backstop  # Also enables auto-start
```

**Disable auto-start:**

```bash
# Systemd
sudo systemctl disable backstop

# OpenRC
sudo rc-update del backstop default

# macOS
brew services stop backstop
```

---

### Configuration

**Default Port:** 2226 (HTTPS) - *Named after Carlton Fisk's games caught record*

Backstop uses TOML for configuration. Create `/etc/backstop/backstop.toml`:

```toml
[server]
port = 2226

[tls]
keystore_path = "/etc/backstop/backstop.p12"
keystore_password = "backstop"
```

**Full example:**

```bash
# Copy example config
sudo cp /etc/backstop/backstop.toml.example /etc/backstop/backstop.toml

# Edit configuration
sudo nano /etc/backstop/backstop.toml

# Restart service
sudo systemctl restart backstop
```

**Environment variable overrides:**

Environment variables take precedence over the TOML file:

```bash
# Override port
export BACKSTOP_PORT=9443

# Override config file location
export BACKSTOP_CONFIG=/custom/path/backstop.toml
```

**Port 2226:** Carlton Fisk caught 2,226 games for the Red Sox and White Sox - the most by any catcher when he retired. A tribute to one of baseball's greatest backstops seemed fitting for this project.

**Alternative ports if 2226 conflicts:**
- 8443 - HTTPS alternate
- 9443 - Another HTTPS alternate
- 3371 - Mike Piazza's hits (catcher offensive record)
- 3000-3999 - Development range

**Testing:**

```bash
# Test the server
curl -k https://localhost:2226/status

# Or with custom port
curl -k https://localhost:9443/status
```

---

## Switching Channels

### APT: Stable ↔ Edge

```bash
# To edge
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo edge main" | sudo tee /etc/apt/sources.list.d/backstop.list
sudo apt update && sudo apt install --only-upgrade backstop

# To stable
echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-repo stable main" | sudo tee /etc/apt/sources.list.d/backstop.list
sudo apt update && sudo apt install backstop
```

### YUM: Stable ↔ Edge

Edit `/etc/yum.repos.d/backstop.repo` and change `stable` to `edge` (or vice versa) in the `baseurl`, then:

```bash
sudo yum clean all
sudo yum update backstop
```

---

## Uninstall

<details>
<summary><b>Debian/Ubuntu</b></summary>

```bash
sudo apt remove backstop
sudo rm /etc/apt/sources.list.d/backstop.list
sudo rm /usr/share/keyrings/backstop-archive-keyring.gpg
```
</details>

<details>
<summary><b>RHEL/Amazon Linux</b></summary>

```bash
sudo yum remove backstop
sudo rm /etc/yum.repos.d/backstop.repo
```
</details>

<details>
<summary><b>Alpine Linux</b></summary>

```bash
apk del backstop
# Remove repository line from /etc/apk/repositories
sed -i '/backstop-repo/d' /etc/apk/repositories
```
</details>

<details>
<summary><b>Snap</b></summary>

```bash
sudo snap remove backstop
```
</details>

<details>
<summary><b>macOS</b></summary>

```bash
brew services stop backstop
brew uninstall backstop
brew untap efsavage/backstop
```
</details>

---

## Channels

- **stable** - Released versions only (tagged releases like v0.1.0)
- **edge** - Latest builds from main branch (development builds)

---

## Repository Maintenance

This repository is automatically updated by GitHub Actions when new versions of Backstop are released.

- Stable packages are published when version tags (v*) are pushed
- Edge packages are published on every commit to main

---

## Issues

For issues with Backstop itself, please visit: https://github.com/efsavage/backstop/issues

For issues with this repository, please visit: https://github.com/efsavage/backstop-repo/issues
