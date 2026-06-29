#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

TARGET_DIR="/usr/local/lib/null"
BIN_DIR="/usr/local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Enforce Root Privileges
if [ "$EUID" -ne 0 ]; then
    echo "[+] Error: Please run as root (sudo)."
    exit 1
fi

# 2. Enforce Distribution Check
if [ ! -f /etc/arch-release ]; then
    echo "[+] Error: This installer is strictly optimized for Arch-based distributions."
    exit 1
fi

# 3. Install Dependencies (Added -y flag to guarantee database sync inside live environment)
echo "[+] Installing core build system packages..."
pacman -Sy --needed --noconfirm make openssh figlet sshfs

echo "[+] Cleaning up any previous installations..."
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"

# 4. Copy Local Source to Target Directory
echo "[+] Deploying source to system libraries..."
cp -R "${SCRIPT_DIR}/." "${TARGET_DIR}/"

# 5. Compile Components via Makefile
echo "[+] Compiling components via Makefile..."
cd "${TARGET_DIR}/src"
make

# 6. Deploy Binary and Set Permissions
echo "[+] Deploying binary to system path..."
cp "${TARGET_DIR}/src/null/null" "${BIN_DIR}/"
chmod 755 "${BIN_DIR}/null"

# 7. Configure Shell Aliases for the Real User
echo "[+] Configuring shell aliases..."

# Try to grab the username of the person who called sudo
REAL_USER="${SUDO_USER:-$USER}"

# Fix: If running under automated setup (root environment) but jaylub user exists, force target jaylub
if [ "$REAL_USER" = "root" ] && id "jaylub" &>/dev/null; then
    REAL_USER="jaylub"
fi

# Get the home directory path for that specific target user from the system database
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# Fallback check just in case getent failed or returned empty
if [ -z "$REAL_HOME" ] || [ "$REAL_HOME" = "/root" ] && [ "$REAL_USER" != "root" ]; then
    REAL_HOME="/home/${REAL_USER}"
fi

ALIAS_LINE="alias ccd='source /usr/local/lib/null/src/mode/ccd'"
RC_FILES=(".bashrc" ".zshrc")

echo "[+] Target user detected: ${REAL_USER} (Home: ${REAL_HOME})"

for rc in "${RC_FILES[@]}"; do
    RC_PATH="${REAL_HOME}/${rc}"

    if [ -f "$RC_PATH" ]; then
        if ! grep -Fq "$ALIAS_LINE" "$RC_PATH"; then
            echo "$ALIAS_LINE" >> "$RC_PATH"
            chown "${REAL_USER}:${REAL_USER}" "$RC_PATH"
            echo "[+] Added 'ccd' alias to ${RC_PATH}"
        else
            echo "[+] 'ccd' alias already exists in ${RC_PATH}"
        fi
    else
        echo "[+] Skipped ${RC_PATH} (File does not exist)"
    fi
done

echo "[+] Optimization and deployment completely operational."
echo "[+] Note: Restart your terminal or run 'source ~/.zshrc' (or ~/.bashrc) to apply the alias instantly."
