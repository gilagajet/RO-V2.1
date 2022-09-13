#!/bin/bash
#=================================================
# File name: init-settings.sh
# Description: This script will be executed during the first boot
# Author: gilagajet
# Contact: t.me/gilagajet
#=================================================

# Disable autostart by default for some packages
rm -f /etc/rc.d/S99dockerd || true
rm -f /etc/rc.d/S99dockerman || true
rm -f /etc/rc.d/S30stubby || true
rm -f /etc/rc.d/S90stunnel || true

# Check file system during boot
uci set fstab.@global[0].check_fs=1
uci commit

# Disable opkg signature check
sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf

#-----------------------------------------------------------------------------

# Set hostname to OpenWRT
uci set system.@system[0].hostname='OpenWRT'

# Set Timezone to Asia/KL
uci set system.@system[0].timezone='MYT-8'
uci set system.@system[0].zonename='Asia/Kuala Lumpur'
uci commit system

#-----------------------------------------------------------------------------

# Add IP Address Info Checker
# run "myip" using terminal for use
chmod +x /bin/myip

#-----------------------------------------------------------------------------

# Set Custom TTL (cat /proc/sys/net/ipv4/ip_default_ttl)
#cat << 'EOF' >> /etc/firewall.user
#iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
#EOF
#/etc/config/firewall restart
echo "net.ipv4.ip_default_ttl=65" >> /etc/sysctl.conf 
echo "net.ipv6.ip_default_ttl=65" >> /etc/sysctl.conf 

#-----------------------------------------------------------------------------

# LuCI -> System -> Terminal (a.k.a) luci-app-ttyd without login
if ! grep -q "/bin/login -f root" /etc/config/ttyd; then
	cat << "EOF" > /etc/config/ttyd
config ttyd
	option interface '@lan'
	option command '/bin/login -f root'
EOF
	logger "  log : Terminal ttyd patched..."
	echo -e "  log : Terminal ttyd patched..."
fi
#-----------------------------------------------------------------------------

# Tweak1
chmod 755 /etc/crontabs/root
echo '#Clear PageCache' | tee -a /etc/crontabs/root
echo '0 */3 * * * sync; echo 1 > /proc/sys/vm/drop_caches' | tee -a /etc/crontabs/root
echo | tee -a /etc/crontabs/root
echo '#Ping Loop' | tee -a /etc/crontabs/root
echo '* * * * * ping 8.8.8.8' | tee -a /etc/crontabs/root
echo | tee -a /etc/crontabs/root
echo '#Stop Flooding Ping' | tee -a /etc/crontabs/root
echo "* * * * * pgrep ping | awk 'NR >= 3' | xargs -n1 kill" | tee -a /etc/crontabs/root
echo | tee -a /etc/crontabs/root
echo '#Clear Log' | tee -a /etc/crontabs/root
echo "*/59 * * * * /etc/init.d/log restart >/dev/null 2>&1" | tee -a /etc/crontabs/root

# Tweak2
echo | tee -a /etc/sysctl.conf
echo '# increase Linux autotuning TCP buffer limit to 32MB' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem=4096 87380 33554432' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem=4096 65536 33554432' | tee -a /etc/sysctl.conf
echo | tee -a /etc/sysctl.conf
echo '# recommended default congestion control is htcp' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | tee -a /etc/sysctl.conf
echo | tee -a /etc/sysctl.conf
echo '# recommended for hosts with jumbo frames enabled' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_mtu_probing=1' | tee -a /etc/sysctl.conf
echo | tee -a /etc/sysctl.conf
echo '#Others' | tee -a /etc/sysctl.conf
echo 'fs.file-max=1000000' | tee -a /etc/sysctl.conf
echo 'fs.inotify.max_user_instances=8192' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_tw_reuse=1' | tee -a /etc/sysctl.conf
echo 'net.ipv4.ip_local_port_range=1024 65000' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_max_syn_backlog=1024' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_fin_timeout=15' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_intvl=30' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_probes=5' | tee -a /etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_timeout_time_wait=30' | tee -a /etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_timeout_fin_wait=30' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_synack_retries=3' | tee -a /etc/sysctl.conf


exit 0
