#/bin/bash

echo "[+] Installing docker..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

echo "[+] Installing docker shell scripts..."
mkdir /opt/scripts/
wget https://raw.githubusercontent.com/windhamwong/stuff/master/dsh.sh -O /opt/scripts/dsh.sh
wget https://raw.githubusercontent.com/windhamwong/stuff/master/dbash.sh -O /opt/scripts/dbash.sh
