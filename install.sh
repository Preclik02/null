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
  sudo apt install -y figlet
  sudo apt install -y sshfs
elif [ "$distro" = "arch" ]; then
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm git
  sudo pacman -S --noconfirm masscan
  sudo pacman -S --noconfirm gcc
  sudo pacman -S --noconfirm neofetch
  sudo pacman -S --noconfirm sl
  sudo pacman -S --noconfirm tigervnc-viewer
  sudo pacman -S --noconfirm ssh
  sudo pacman -S --noconfirm figlet
  sudo pacman -S --noconfirm sshfs
fi

echo "[+] cloning the null to ~/.null"
mkdir ~/.null
git clone https://github.com/Preclik02/null.git ~/.null

echo "[-] Do you want to compile everything y/N (you will need nullc installed for it to work) >> "
read compile

if [ "$compile" = "y" ]; then
  nullc ~/.null/nc/apps
  nullc ~/.null/nc/dos
  nullc ~/.null/nc/null
  nullc ~/.null/nc/dos_s
  nullc ~/.null/nc/port_scan
  nullc ~/.null/nc/oom
  nullc ~/.null/nc/ssh_connect
  nullc ~/.null/nc/vnc_connect
  nullc ~/.null/nc/server
  nullc ~/.null/nc/dev_mode
  nullc ~/.null/nc/todo
  nullc ~/.null/nc/idek
fi
else
  echo "[+] Okay"
fi

chmod +x ~/.null/nc/apps
chmod +x ~/.null/nc/dos
chmod +x ~/.null/nc/null
chmod +x ~/.null/nc/dos_s
chmod +x ~/.null/nc/port_scan
chmod +x ~/.null/nc/oom
chmod +x ~/.null/nc/ssh_connect
chmod +x ~/.null/nc/vnc_connect
chmod +x ~/.null/nc/server
chmod +x ~/.null/nc/dev_mode
chmod +x ~/.null/nc/todo
chmod +x ~/.null/nc/idek

mkdir ~/.null/cache/ssh

echo "[+] adding the null to path"

if [ "$terminal" = "bash" ]; then
  echo 'export PATH="$HOME/.null/nc:$PATH"' >>~/.bashrc
  echo "[+] now execute this in your terminal 'source ~/.bashrc' and restart it\n[+] than you will be able to run the null by 'null'"
elif [ "$terminal" = "zsh" ]; then
  echo 'export PATH="$HOME/.null/nc:$PATH"' >>~/.zshrc
  echo "[+] now execute this in your terminal 'source ~/.zshrc' and restart it\n[+] than you will be able to run the null by 'null'"
fi
