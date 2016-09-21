echo -e "\e[93m[+] Docker Shell Script\e[97m"
docker ps
echo -e "\e[92m[*] Which docker do you want to attach? \e[97m"
read dockerName
echo -e "\e[92m[*] You are now entering $dockerName...\e[97m"
echo ""
docker exec -i -t $dockerName /bin/bash
