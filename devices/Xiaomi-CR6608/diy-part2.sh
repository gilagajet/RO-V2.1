# =================================================================== #
#                                                                     #
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>                 #
# Copyright (c) 2022 SolomonRicky <http://firmware.download.yzyz.ga>  #
#                                                                     #
# This is free software, licensed under the GNU GPLv3 License.        #
# See /LICENSE for more information.                                  #
#                                                                     #
# =================================================================== #

###Base

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Enable WiFi Interface
sed -i 's/wireless.radio${devidx}.disabled=1/wireless.radio${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Version Update
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='GilaGajet build $(TZ=UTC+8 date "+%Y.%m") '" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='[P-WSS]'" >> package/base-files/files/etc/openwrt_release

# Update TimeZone
sed -i 's/0.openwrt.pool.ntp.org/time.google.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/time.cloudflare.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/clock.sjc.he.net/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/my.pool.ntp.org/g' package/base-files/files/bin/config_generate

###Extra

#upx
#git clone --depth=1 https://github.com/kuoruan/openwrt-upx.git /workdir/openwrt/staging_dir/host/bin/upx


###Script
wget https://raw.githubusercontent.com/gilagajet/gen/xray-wss/import_feeds.sh
chmod +x import_feeds.sh
./import_feeds.sh
