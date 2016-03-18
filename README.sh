#! /bin/bash
apt-get update -y
apt-get upgrade -y
apt-get install pptpd -y
apt-get install curl -y
pptpd -v
apt-get update -y
apt-get upgrade -y
update-rc.d pptpd defaults
echo "localip 172.20.1.1" >> /etc/pptpd.conf
echo "remoteip 172.20.1.2-254" >> /etc/pptpd.conf
echo "ms-dns 8.8.8.8" >> /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >> /etc/ppp/pptpd-options
echo "username	*	Pa55w0rd	*" >> /etc/ppp/chap-secrets 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
service pptpd restart
apt-get install iptables-persistent -y
iptables -I INPUT -p tcp --dport 1723 -m state --state NEW -j ACCEPT
iptables -I INPUT -p gre -j ACCEPT
iptables -t nat -I POSTROUTING -o eth1 -j MASQUERADE
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -s 172.20.1.0/24 -j TCPMSS  --clamp-mss-to-pmtu
service iptables-persistent save
iptables-save >> iptables
EOF
