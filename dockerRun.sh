#!/bin/bash

if [ $# -eq 0 ]
        then
        echo -e "\e[93m[+] Docker Shell Script\e[97m"
        echo -e "\e[93m[+] Usage: ./dockerRun.sh [<image> <name> <args>]\e[97m"
        echo -e "\e[93m[+] Reference: \e[97m"
        echo -e "\e[36m[-] -mem 512m //Limit memory to 512MB \e[97m"
        echo -e "\e[36m[-] -c 512 //Limit CPU to 512 weight (Default: 1024) \e[97m"
        echo -e "\e[36m[-] -p <HostPort>:<ContainerPort> //Port Forward\e[97m"
        echo -e "\e[36m[-] -v <HostPath>:<ContainerPath> //Share Folder\e[97m"
        docker images
        echo -e "\e[92m[*] Which docker do you want to attach? \e[97m"
        read dockerImage
        echo -e "\e[92m[*] What name you want to rename this container? \e[97m"
        read dockerName
else
        dockerImage=$1
        dockerName=$2
        dockerArgs=$3
fi
Rand=$(($RANDOM+1024))
echo -e "\e[92m[*] Creating container...\e[97m"
echo ""
docker run --user=1000 --security-opt=no-new-privileges -p$Rand:22 -dit --name $dockerName $dockerImage /bin/bash

echo -e "\e91m[*] Do you want to do iptables for the container? (Please Enter to continue) \e[97m"
read nothing

containerName=$(docker ps |grep $dockerName |awk '{print $1}')
IP=$(docker inspect $containerName |grep '"IPAddress' |head -n1|cut -d '"' -f4)
echo -e "\e[92m[*] Container Name: $containerName \e[97m"
echo -e "\e[92m[*] SSH PORT: $Rand \e[97m"
echo -e "\e[92m[*] IP Address: $IP \e[97m"
sudo iptables -t nat -A POSTROUTING -s $IP/32 -d $IP/32 -p tcp -m tcp --dport 22 -j MASQUERADE
sudo iptables -t nat -A DOCKER ! -i docker0 -p tcp -m tcp --dport $Rand -j DNAT --to-destination $IP:22
sudo iptables -t filter -A DOCKER -d $IP/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 22 -j ACCEPT

echo -e "\e91m[*] Do you want to access onto the container now? (Please Enter to continue \e[97m"
read nothing
sh /home/windhamwong/dockerShell.sh $containerName
