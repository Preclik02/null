#!/bin/bash

echo "what distro do you use (debian/arch)"
read distro
echo "what is you terminal (zsh/bash)"
read terminal

echo "[+] trigering sudo . . ."
sudo -v

echo "[+] installing packages for null to work"

if [ "$distro" = "debian" ]; then
  sudo apt update
  sudo apt install -y git
  sudo apt install -y masscan
  sudo apt install -y gcc
  sudo apt install -y neofetch
  sudo apt install -y sl
  sudo apt install -y tigervnc-viewer
  sudo apt install -y ssh
elif [ "$distro" = "arch" ]; then
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm git
  sudo pacman -S --noconfirm masscan
  sudo pacman -S --noconfirm gcc
  sudo pacman -S --noconfirm neofetch
  sudo pacman -S --noconfirm sl
  sudo pacman -S --noconfirm tigervnc-viewer
  sudo pacman -S --noconfirm ssh
fi

echo "[+] cloning the null to ~/.null"
mkdir ~/.null
git clone https://github.com/Preclik02/null.git ~/.null
chmod +x ~/.null/nc/apps
chmod +x ~/.null/nc/dos
chmod +x ~/.null/nc/null
chmod +x ~/.null/nc/dos_s
chmod +x ~/.null/nc/port_scan
chmod +x ~/.null/nc/rpg
chmod +x ~/.null/nc/ssh_connect
chmod +x ~/.null/nc/vnc_connect
chmod +x ~/.null/nc/server
chmod +x ~/.null/nc/dev_mode
chmod +x ~/.null/nc/todo
chmod +x ~/.null/nc/idek

echo "[+] adding the null to path"

if [ "$terminal" = "bash" ]; then
  echo 'export PATH="$HOME/.null/nc:$PATH"' >>~/.bashrc
  echo "[+] now execute this in your terminal 'source ~/.bashrc' and restart it\n[+] than you will be able to run the null by 'null'"
elif [ "$terminal" = "zsh" ]; then
  echo 'export PATH="$HOME/.null/nc:$PATH"' >>~/.zshrc
  echo "[+] now execute this in your terminal 'source ~/.zshrc' and restart it\n[+] than you will be able to run the null by 'null'"
fi
