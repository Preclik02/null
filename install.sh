#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- System Paths ---
TARGET_DIR="/usr/local/lib/null"
BIN_DIR="/usr/local/bin"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "[-] Please run as root (sudo)."
    exit 1
fi

# Ensure it is running on an Arch-based system
if [ ! -f /etc/arch-release ]; then
    echo "[-] Error: This installer is strictly optimized for Arch-based distributions."
    exit 1
fi

echo "[+] Installing core build system packages..."
# Only installing make, sl, openssh, figlet, and sshfs now.
pacman -Syu --needed --noconfirm make sl openssh figlet sshfs

echo "[+] Cleaning up any previous installations..."
rm -rf "${TARGET_DIR}"

echo "[+] Cloning the repository to system libraries..."
git clone https://github.com/jaylubiny/null.git "${TARGET_DIR}"

echo "[+] Compiling components via Makefile..."
cd "${TARGET_DIR}/src"
make

echo "[+] Deploying binary to system path..."
cp "${TARGET_DIR}/src/null/null" "${BIN_DIR}/"

echo "[+] Adjusting executable permissions..."
chmod +x "${BIN_DIR}/null"

echo "[+] Optimization and deployment completely operational."
