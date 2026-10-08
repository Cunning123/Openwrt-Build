```bash
#!/bin/bash
# Copyright (c) 2019-2020 P3TERX

cd "${HOME_PATH}" || exit 1

# 清理冲突
rm -rf ${HOME_PATH}/package/mihomo-alpha
rm -rf ${HOME_PATH}/package/mihomo-meta
rm -rf ${HOME_PATH}/package/kmod-oaf
rm -rf ${HOME_PATH}/package/appfilter
rm -rf ${HOME_PATH}/package/luci-app-oaf
rm -rf ${HOME_PATH}/package/OpenAppFilter
rm -rf ${HOME_PATH}/package/new/mihomo-alpha
rm -rf ${HOME_PATH}/package/new/mihomo-meta
rm -rf ${HOME_PATH}/package/new/kmod-oaf
rm -rf ${HOME_PATH}/package/new/appfilter
rm -rf ${HOME_PATH}/package/new/luci-app-oaf
rm -rf ${HOME_PATH}/package/new/OpenAppFilter


# 删除不用插件
rm -rf ${HOME_PATH}/package/luci-app-bypass
rm -rf ${HOME_PATH}/package/luci-app-netdata
rm -rf ${HOME_PATH}/package/netdata
rm -rf ${HOME_PATH}/package/luci-i18n-netdata-zh-cn
rm -rf ${HOME_PATH}/package/luci-app-ddns
rm -rf ${HOME_PATH}/package/ddns-scripts
rm -rf ${HOME_PATH}/package/ddns-scripts-services


# PassWall
grep -q "src-git passwall_luci" feeds.conf.default || \
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default

grep -q "src-git passwall_packages" feeds.conf.default || \
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default


# PassWall2
grep -q "src-git passwall2" feeds.conf.default || \
echo "src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main" >> feeds.conf.default


# OpenClash
grep -q "src-git openclash" feeds.conf.default || \
echo "src-git openclash https://github.com/vernesong/OpenClash.git;master" >> feeds.conf.default


# iStore
grep -q "src-git istore" feeds.conf.default || \
echo "src-git istore https://github.com/linkease/istore.git;main" >> feeds.conf.default


# 清理插件
rm -rf ${HOME_PATH}/package/luci-app-v2ray-server
rm -rf ${HOME_PATH}/package/luci-app-wechatpush
rm -rf ${HOME_PATH}/package/luci-app-autoupdate
rm -rf ${HOME_PATH}/package/luci-app-singbox-ui
rm -rf ${HOME_PATH}/package/luci-i18n-istore-zh-cn
rm -rf ${HOME_PATH}/package/luci-i18n-quickstart-zh-cn



# MosDNS v5
# 删除源码自带的 MosDNS，改用 sbwml/luci-app-mosdns
rm -rf ${HOME_PATH}/package/mosdns
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-mosdns
rm -rf ${HOME_PATH}/feeds/packages/net/mosdns

find ${HOME_PATH}/feeds -type f \
    \( -name Makefile -o -name Kconfig \) \
    -path '*mosdns*' \
    -delete 2>/dev/null || true

git clone -q \
    https://github.com/sbwml/luci-app-mosdns.git \
    ${HOME_PATH}/package/mosdns

cd ${HOME_PATH}/package/mosdns || exit 1

git checkout -q df6d67b84d32246081e259f3cb93dae63962a1fc

cd ${HOME_PATH} || exit 1

echo "检查 MosDNS"
if [ -f "${HOME_PATH}/package/mosdns/mosdns/Makefile" ]; then
    echo "[OK] MosDNS 5.3.4"
else
    echo "[WARN] MosDNS 源码未找到"
fi

if [ -f "${HOME_PATH}/package/mosdns/luci-app-mosdns/Makefile" ]; then
    echo "[OK] luci-app-mosdns 1.7.13"
else
    echo "[WARN] luci-app-mosdns 未找到"
fi




# V2Ray Server
rm -rf /tmp/coolsnowwolf-luci

git clone -q --depth=1 \
https://github.com/coolsnowwolf/luci.git \
/tmp/coolsnowwolf-luci

if [ -d "/tmp/coolsnowwolf-luci/applications/luci-app-v2ray-server" ]; then
cp -Rf \
/tmp/coolsnowwolf-luci/applications/luci-app-v2ray-server \
${HOME_PATH}/package/luci-app-v2ray-server
fi

rm -rf /tmp/coolsnowwolf-luci


# 微信推送
git clone -q --depth=1 \
https://github.com/tty228/luci-app-wechatpush.git \
${HOME_PATH}/package/luci-app-wechatpush


# 自动升级
git clone -q --depth=1 \
https://github.com/281677160/luci-app-autoupdate.git \
${HOME_PATH}/package/luci-app-autoupdate


# Sing-box UI
git clone -q --depth=1 \
https://github.com/ang3el7z/luci-app-singbox-ui.git \
${HOME_PATH}/package/luci-app-singbox-ui

# iStore 中文语言包
git clone -q --depth=1 \
https://github.com/linkease/istore.git \
/tmp/istore

if [ -d "/tmp/istore/luci-i18n-istore-zh-cn" ]; then
cp -Rf \
/tmp/istore/luci-i18n-istore-zh-cn \
${HOME_PATH}/package/luci-i18n-istore-zh-cn
fi

if [ -d "/tmp/istore/luci-i18n-quickstart-zh-cn" ]; then
cp -Rf \
/tmp/istore/luci-i18n-quickstart-zh-cn \
${HOME_PATH}/package/luci-i18n-quickstart-zh-cn
fi

rm -rf /tmp/istore


    
# 后台IP设置
export Ipv4_ipaddr="192.168.2.99"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）
export Op_name="OpenWrt"                    # 修改主机名称为OpenWrt-123(填0为不作修改)

# 内核和系统分区大小(不是每个机型都可用)
export Kernel_partition_size="256"           # 内核分区大小,每个机型默认值不一样
export Rootfs_partition_size="512"           # 系统分区大小,每个机型默认值不一样

# 默认主题设置
export Mandatory_theme="argon"
export Default_theme="argon"

# 旁路由选项
export Gateway_Settings="192.168.2.1"
export DNS_Settings="192.168.2.1"
export Broadcast_Ipv4="255.255.255.255"
export Disable_DHCP="1"
export Disable_Bridge="1"
export Create_Ipv6_Lan="1"

# IPV6、IPV4 选择
export Enable_IPV6_function="1"
export Enable_IPV4_function="0"

# 替换OpenClash的源码(默认master分支)
export OpenClash_branch="0"

# 个性签名
export Customized_Information="$(TZ=UTC-8 date "+%Y.%m.%d")"

# 更换固件内核
export Replace_Kernel="0"

# 设置免密码登录
export Password_free_login="1"

# 增加AdGuardHome插件和核心
export AdGuardHome_Core="0"

# 开启NTFS格式盘挂载
export Automatic_Mount_Settings="1"

# 去除网络共享(autosamba)
export Disable_autosamba="0"

# 其他
export Ttyd_account_free_login="1"
export Delete_unnecessary_items="1"
export Disable_53_redirection="0"
export Cancel_running="1"


# 晶晨CPU系列打包固件设置
export amlogic_model="s905d"
export amlogic_kernel="6.1.120_6.12.15"
export auto_kernel="true"
export rootfs_size="512/2560"
export kernel_usage="stable"


# 修改插件名称
grep -rl '"终端"' . | xargs -r sed -i 's?"终端"?"TTYD"?g'
grep -rl '"TTYD 终端"' . | xargs -r sed -i 's?"TTYD 终端"?"TTYD"?g'
grep -rl '"网络存储"' . | xargs -r sed -i 's?"网络存储"?"NAS"?g'
grep -rl '"实时流量监测"' . | xargs -r sed -i 's?"实时流量监测"?"流量"?g'
grep -rl '"KMS 服务器"' . | xargs -r sed -i 's?"KMS 服务器"?"KMS激活"?g'
grep -rl '"USB 打印服务器"' . | xargs -r sed -i 's?"USB 打印服务器"?"打印服务"?g'
grep -rl '"Web 管理"' . | xargs -r sed -i 's?"Web 管理"?"Web管理"?g'
grep -rl '"管理权"' . | xargs -r sed -i 's?"管理权"?"改密码"?g'
grep -rl '"带宽监控"' . | xargs -r sed -i 's?"带宽监控"?"监控"?g'


echo "检查自定义插件"

for PKG in \
luci-app-v2ray-server \
luci-app-wechatpush \
luci-app-autoupdate \
luci-app-singbox-ui \
luci-i18n-istore-zh-cn
do
    if [ -f "${HOME_PATH}/package/${PKG}/Makefile" ]; then
        echo "[OK] ${PKG}"
    else
        echo "[WARN] ${PKG} 未找到"
    fi
done


echo "检查冲突包"

find "${HOME_PATH}/package" -type f \
\( -name Makefile -o -name Kconfig \) \
-print0 2>/dev/null |
xargs -0 grep -IlE \
'mihomo-alpha|mihomo-meta|kmod-oaf' \
2>/dev/null || true


echo "检查 feeds"

grep -E \
'Openwrt-Passwall|OpenClash|linkease/istore' \
"${HOME_PATH}/feeds.conf.default" || true


# ============================================================
# dnsmasq + PassWall 编译期修复
#
# PassWall 会写入：
# dhcp.@dnsmasq[0].addnmount='/tmp/etc/passwall/acl/default/dnsmasq.d'
#
# OpenWrt dnsmasq 使用 procd jail。
# 如果 addnmount 没有加入 EXTRA_MOUNT，
# dnsmasq 在 jail 内无法访问上述目录，会导致启动失败。
#
# 这里直接修改编译源码中的 dnsmasq.init，
# 让最终生成的固件永久包含此修复。
# ============================================================

echo "===== 检查 dnsmasq init ====="

DNSMASQ_INIT="$(find "${HOME_PATH}" \
    -type f \
    \( -path '*/dnsmasq/files/dnsmasq.init' -o -name 'dnsmasq.init' \) \
    2>/dev/null | head -n 1)"

if [ -n "${DNSMASQ_INIT}" ] && [ -f "${DNSMASQ_INIT}" ]; then

    echo "[OK] 找到 dnsmasq.init:"
    echo "     ${DNSMASQ_INIT}"

    # --------------------------------------------------------
    # 1. 增加 addnmount -> EXTRA_MOUNT 函数
    # --------------------------------------------------------

    if grep -q 'append_addnmount()' "${DNSMASQ_INIT}"; then

        echo "[OK] append_addnmount() 已存在"

    else

        sed -i '/^append_addnhosts() {/i\
append_addnmount() {\
        append EXTRA_MOUNT "$1"\
}\
' "${DNSMASQ_INIT}"

        if grep -q 'append_addnmount()' "${DNSMASQ_INIT}"; then
            echo "[OK] 已添加 append_addnmount()"
        else
            echo "[ERROR] append_addnmount() 添加失败"
            exit 1
        fi

    fi


    # --------------------------------------------------------
    # 2. 读取 UCI addnmount 并加入 dnsmasq jail
    # --------------------------------------------------------

    if grep -q 'config_list_foreach "$cfg" addnmount append_addnmount' "${DNSMASQ_INIT}"; then

        echo "[OK] addnmount -> EXTRA_MOUNT 已存在"

    else

        sed -i '/^[[:space:]]*procd_add_jail dnsmasq ubus log/i\
        config_list_foreach "$cfg" addnmount append_addnmount' "${DNSMASQ_INIT}"

        if grep -q 'config_list_foreach "$cfg" addnmount append_addnmount' "${DNSMASQ_INIT}"; then
            echo "[OK] 已添加 addnmount -> EXTRA_MOUNT"
        else
            echo "[ERROR] addnmount -> EXTRA_MOUNT 添加失败"
            exit 1
        fi

    fi


    # --------------------------------------------------------
    # 3. 编译前检查 dnsmasq.init shell 语法
    # --------------------------------------------------------

    if sh -n "${DNSMASQ_INIT}"; then
        echo "[OK] dnsmasq.init shell 语法检查通过"
    else
        echo "[ERROR] dnsmasq.init shell 语法检查失败"
        exit 1
    fi


    # --------------------------------------------------------
    # 4. 输出最终关键代码，方便 Actions 日志检查
    # --------------------------------------------------------

    echo "===== dnsmasq addnmount 修复结果 ====="

    grep -n -A4 -B2 \
        'append_addnmount()' \
        "${DNSMASQ_INIT}" || true

    grep -n -A3 -B3 \
        'config_list_foreach "$cfg" addnmount append_addnmount' \
        "${DNSMASQ_INIT}" || true

    echo "===== dnsmasq 修复完成 ====="

else

    echo "[ERROR] 未找到 dnsmasq.init"
    echo "请检查 OpenWrt 源码目录结构"
    exit 1

fi


# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
openwrt-x86-64-generic-kernel.bin
openwrt-x86-64-generic.manifest
openwrt-x86-64-generic-squashfs-rootfs.img.gz
EOF

# 在线更新时，删除不想保留固件的某个文件
cat >>$DELETE <<-EOF
EOF
```
