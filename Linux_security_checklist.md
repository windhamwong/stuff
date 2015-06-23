#Linux Security Check List
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

net.ipv6.conf.default.accept_ra_pinfo = 0

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

***
###Nginx
######/etc/nginx/nginx.conf
server_tokens off;

***
###sudo
######/etc/sudoers
[username]  ALL=(ALL:ALL) ALL

***
###SSH Cert
ssh-keygen -t rsa -b 2048

cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

######/etc/ssh/sshd_config
PasswordAuthentication no

###Limit su permission
apt-get install sudo
######/etc/sudoers
[USERNAME]  ALL=(ALL) ALL
######/etc/pam.d/su
auth required pam_wheel.so use_uid