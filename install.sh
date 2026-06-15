#!/bin/bash

# --- Environment Constants ---
TARGET_USER="jaylub"
USER_HOME="/home/${TARGET_USER}"

echo "[+] Customizing environment for ${TARGET_USER}..."

echo "[+] Updating system and installing required tools..."
pacman -Syu --noconfirm git masscan gcc neofetch sl tigervnc-viewer openssh figlet sshfs

echo "[+] Creating clean structure..."
mkdir -p "${USER_HOME}/.null/nc"
mkdir -p "${USER_HOME}/.null/cache/ssh"

echo "[+] Downloading environment configurations..."
git clone https://github.com/Preclik02/null.git "${USER_HOME}/.null_repo"

# Move the text files and configurations to the active directory structure
cp -r "${USER_HOME}/.null_repo/"* "${USER_HOME}/.null/"
rm -rf "${USER_HOME}/.null_repo"

# --- Automated GCC Compilation Layer ---
echo "[+] Compiling custom security tools with GCC..."

# This loop finds every .c file in your source directories and compiles it
cd "${USER_HOME}/.null/nc"
for source_file in apps dos null dos_s port_scan oom ssh_connect vnc_connect server dev_mode todo idek; do
    if [ -f "${source_file}.c" ]; then
        echo "    -> Compiling ${source_file}.c with GCC..."
        gcc "${source_file}.c" -o "${source_file}"
    elif [ -f "${source_file}" ]; then
        echo "    -> ${source_file} is a script, skipping compilation."
    fi
done

echo "[+] Adjusting executable permissions..."
chmod +x "${USER_HOME}"/.null/nc/*

echo "[+] Configuring PATH variables for Zsh shell execution environment..."
echo 'export PATH="$HOME/.null/nc:$PATH"' >> "${USER_HOME}/.zshrc"

echo "[+] Correcting workspace file ownership permissions..."
chown -R ${TARGET_USER}:${TARGET_USER} "${USER_HOME}"

echo "[+] JayOS Secure Wrapper deployment completely optimized and operational."
