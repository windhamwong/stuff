#!/bin/bash
# written by Tomas Nevar (http://www.lisenet.com)
# 17/01/2014 (dd/mm/yy)
# copyleft free software
#
LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log"; 
EMAIL_MSG="Please see the log file attached."; 
EMAIL_FROM="clamav-daily@example.com";
EMAIL_TO="username@example.com";
DIRTOSCAN="/home";

# Update ClamAV database
echo "Looking for ClamAV database updates...";
freshclam --quiet;

TODAY=$(date +%u);

if [ "$TODAY" == "6" ];then
 echo "Starting a full weekend scan.";

 # be nice to others while scanning the entire root
 nice -n5 clamscan -ri / --exclude-dir=/sys/ &>"$LOGFILE";
else
 DIRSIZE=$(du -sh "$DIRTOSCAN" 2>/dev/null | cut -f1);

 echo "Starting a daily scan of "$DIRTOSCAN" directory.
 Amount of data to be scanned is "$DIRSIZE".";

 clamscan -ri "$DIRTOSCAN" &>"$LOGFILE";
fi

# get the value of "Infected lines" 
MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3); 

# if the value is not equal to zero, send an email with the log file attached 
if [ "$MALWARE" -ne "0" ];then 
  #using heirloom-mailx below 
  echo "$EMAIL_MSG"|mail -a "$LOGFILE" -s "Malware Found" -r "$EMAIL_FROM" "$EMAIL_TO"; 
fi 
exit 0