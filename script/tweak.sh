# Tweak1
chmod 755 /etc/crontabs/root
echo '#Auto clear buffer/cache' | tee -a /etc/crontabs/root
echo '0 */3 * * * sync; echo 1 > /proc/sys/vm/drop_caches' | tee -a /etc/crontabs/root
echo '#PingLoop' | tee -a /etc/crontabs/root
echo '* * * * * ping 9.9.9.9' | tee -a /etc/crontabs/root
echo '#Stop Flooding Ping' | tee -a /etc/crontabs/root
echo "* * * * * pgrep ping | awk 'NR >= 3' | xargs -n1 kill" | tee -a /etc/crontabs/root

# Tweak2
echo '# increase Linux autotuning TCP buffer limit to 32MB' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem=4096 87380 33554432' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem=4096 65536 33554432' | tee -a /etc/sysctl.conf
echo '# recommended default congestion control is htcp' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | tee -a /etc/sysctl.conf
echo '# recommended for hosts with jumbo frames enabled' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_mtu_probing=1' | tee -a /etc/sysctl.conf
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

rm -rf /tmp/luci-modulecache/
rm -f /tmp/luci-indexcache
