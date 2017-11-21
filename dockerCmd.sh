echo "" >> ~/.bashrc
echo "# Docker commands" >> ~/.bashrc
echo "alias dils='docker image ls'" >> ~/.bashrc
echo "alias dsh=~/dockerShell.sh" >> ~/.bashrc
echo "alias dps=\"docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}\t{{.Command}}'\"" >> ~/.bashrc