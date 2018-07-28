#!/bin/bash

echo "[+] Automated installation script"

echo "[+] Installing new bash interface..."
wget https://raw.githubusercontent.com/windhamwong/stuff/master/.bashrc -O ~/.bashrc

echo "[+] installing byobu..."
sudo apt-get install byobu -y
mkdir ~/.byobu
rm -rf ~/.byobu/.tmux.conf ~/.byobu/status
wget https://raw.githubusercontent.com/windhamwong/stuff/master/.byobu/.tmux.conf -O ~/.byobu/.tmux.conf
wget https://raw.githubusercontent.com/windhamwong/stuff/master/.byobu/status -O ~/.byobu/status

source ~/.bashrc