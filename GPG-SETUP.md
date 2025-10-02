# GPG Signing Setup for Backstop APT Repository

This guide walks through setting up GPG signing for the APT repository to enable verified package installation.

## Step 1: Generate GPG Key

Generate a GPG key pair for signing packages:

```bash
gpg --full-generate-key
```

Configuration:
- Key type: **(1) RSA and RSA**
- Key size: **4096**
- Expiration: **0** (does not expire) or set expiration date
- Real name: **Backstop Repository**
- Email: **backstop@efsavage.com** (or your email)
- Comment: **APT package signing key**

## Step 2: Export Public Key

Export the public key for users to verify packages:

```bash
cd /root/backstop-apt
gpg --armor --export backstop@efsavage.com > KEY.gpg
```

## Step 3: Export Private Key for GitHub Actions

Export the private key to add to GitHub Secrets:

```bash
gpg --armor --export-secret-keys backstop@efsavage.com
```

Copy the entire output (including `-----BEGIN PGP PRIVATE KEY BLOCK-----` and `-----END PGP PRIVATE KEY BLOCK-----`).

## Step 4: Add to GitHub Secrets

1. Go to https://github.com/efsavage/backstop-apt/settings/secrets/actions
2. Click "New repository secret"
3. Name: `GPG_PRIVATE_KEY`
4. Value: Paste the private key from Step 3
5. Click "Add secret"

Also add the passphrase (if you set one):
1. Click "New repository secret"
2. Name: `GPG_PASSPHRASE`
3. Value: Your GPG key passphrase
4. Click "Add secret"

## Step 5: Get Key ID

Find your key ID for the update script:

```bash
gpg --list-secret-keys --keyid-format=long
```

Look for a line like:
```
sec   rsa4096/ABCD1234EFGH5678 2025-10-02 [SC]
```

The key ID is `ABCD1234EFGH5678` (the part after `rsa4096/`).

## Step 6: Commit Public Key

```bash
cd /root/backstop-apt
git add KEY.gpg
git commit -m "Add GPG public key for package verification"
git push
```

## Step 7: Update Workflows

The `update-repo.sh` script and GitHub Actions workflow have been updated to automatically sign packages using the GPG key.

## Verification

After setup, users can install packages with GPG verification:

```bash
# Add repository with GPG verification
curl -fsSL https://efsavage.github.io/backstop-apt/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/backstop-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/backstop-archive-keyring.gpg] https://efsavage.github.io/backstop-apt stable main" | sudo tee /etc/apt/sources.list.d/backstop.list

sudo apt update
sudo apt install backstop
```

APT will verify packages using the public key and warn if signatures don't match.
