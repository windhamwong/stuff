#Notes
***
###/etc/sysctl.conf
	net.ipv4.icmp_echo_ignore_all = 1
	net.ipv4.icmp_ignore_bogus_error_responses = 1
	net.ipv4.tcp_syncookies = 1
	net.ipv4.conf.all.log_martians = 1
	net.ipv4.conf.default.log_martians = 1
	net.ipv4.conf.all.accept_source_route = 0
	net.ipv4.conf.default.accept_source_route = 0
	net.ipv4.conf.all.rp_filter = 1
	net.ipv4.conf.default.rp_filter = 1
	net.ipv4.conf.all.accept_redirects = 0
	net.ipv4.conf.default.accept_redirects = 0
	net.ipv4.conf.all.secure_redirects = 0
	net.ipv4.conf.default.secure_redirects = 0
	net.ipv4.ip_forward = 0
	net.ipv4.conf.all.send_redirects = 0
	net.ipv4.conf.default.send_redirects = 0
	kernel.randomize_va_space = 1
	net.ipv6.conf.default.router_solicitations = 0
	net.ipv6.conf.default.accept_ra_rtr_pref = 0
	net.ipv6.conf.default.accept_ra_pinfo = 
	net.ipv6.conf.default.accept_ra_defrtr = 0
	net.ipv6.conf.default.autoconf = 0
	net.ipv6.conf.default.dad_transmits = 0
	net.ipv6.conf.default.max_addresses = 1
	fs.file-max = 65535
	net.ipv4.ip_local_port_range = 2000 65000
	net.ipv4.tcp_rmem = 4096 87380 8388608
	net.ipv4.tcp_wmem = 4096 87380 8388608
	net.core.rmem_max = 8388608
	net.core.wmem_max = 8388608
	net.core.netdev_max_backlog = 5000
	net.ipv4.tcp_window_scaling = 1

###Nginx
######/etc/nginx/nginx.conf
	server_tokens off;

***
###SSH Cert
	ssh-keygen -t rsa -b 2048
	cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

######/etc/ssh/sshd_config
	PasswordAuthentication no

######/etc/sudoers
	[USERNAME]  ALL=(ALL) ALL

######/etc/pam.d/su
	auth required pam_wheel.so use_uid

######ClamAV Automated Scanning Script
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

***
######/etc/modsecurity/modsecurity.conf
	SecRuleEngine On
	SecResponseBodyAccess Off

######/etc/apache2/mods-enabled/mod-security.conf
	Include "/usr/share/modsecurity-crs/*.conf"
	
	Include "/usr/share/modsecurity-crs/activated_rules/*.conf"

######Activate rules
	cd /usr/share/modsecurity-crs/activated_rules/
	ln -s /usr/share/modsecurity-crs/base_rules/* .

###Mod-evasive
	apt-get install mod_evasive
	yum install mod_evasive

***
###iptables

	-A INPUT -i lo -j ACCEPT
    -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
    -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
    -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    
***
###MongoDB
#####Adding new user to specific database
	  use test  
	  db.createUser(  
	     {  
	       user: "mynewuser",  
	       pwd: "myuser123",  
	       roles: [ "readWrite", "dbAdmin" ]  
	     }  
	  );  

***
###CoreOS
####rkt
https://coreos.com/rkt/docs/latest/subcommands/run.html

######Launch an image that is not signed
	--insecure-options=image

######Network
	--net=host #Specific host's network stack

######Instance list
	rkt list

######rkt docker image
	rkt run --interactive docker://ubuntu --insecure-options=image

######Create image
	acbuild begin
	acbuild set-name example.com/hello
	acbuild copy hello /bin/hello
	acbuild set-exec /bin/hello
	acbuild write hello-latest-linux-amd64.aci
	acbuild end
	actool validate hello-latest-linux-amd64.aci

	rkt run --insecure-options=image --net=host hello-0.0.1-linux-amd64.aci