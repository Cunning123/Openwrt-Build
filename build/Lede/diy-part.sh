#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好


# =========================================================
# 进入源码目录
# =========================================================

cd "${HOME_PATH}" || exit 1


# =========================================================
# 清理可能造成 Kconfig 递归依赖的插件
# =========================================================

rm -rf "${HOME_PATH}/package/mihomo-alpha"
rm -rf "${HOME_PATH}/package/mihomo-meta"

rm -rf "${HOME_PATH}/package/kmod-oaf"
rm -rf "${HOME_PATH}/package/appfilter"
rm -rf "${HOME_PATH}/package/luci-app-oaf"
rm -rf "${HOME_PATH}/package/OpenAppFilter"

rm -rf "${HOME_PATH}/package/new/mihomo-alpha"
rm -rf "${HOME_PATH}/package/new/mihomo-meta"
rm -rf "${HOME_PATH}/package/new/kmod-oaf"
rm -rf "${HOME_PATH}/package/new/appfilter"
rm -rf "${HOME_PATH}/package/new/luci-app-oaf"
rm -rf "${HOME_PATH}/package/new/OpenAppFilter"


# =========================================================
# 官方插件 Feed
#
# 注意：
# common 后面会自行：
# ./scripts/feeds update -a
# ./scripts/feeds install -a
#
# 所以这里只提前写 feeds.conf.default
# =========================================================


# =========================================================
# PassWall 官方 Feed
# =========================================================

grep -q 'src-git passwall_luci ' feeds.conf.default || \
echo 'src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main' >> feeds.conf.default

grep -q 'src-git passwall_packages ' feeds.conf.default || \
echo 'src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main' >> feeds.conf.default


# =========================================================
# PassWall2 官方 Feed
# =========================================================

grep -q 'src-git passwall2 ' feeds.conf.default || \
echo 'src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main' >> feeds.conf.default


# =========================================================
# OpenClash 官方 Feed
#
# 由于 common 自己会根据 OpenClash_branch 加 Feed
# 这里关闭 common 自动添加，避免重复
# =========================================================

export OpenClash_branch="0"

grep -q 'src-git openclash ' feeds.conf.default || \
echo 'src-git openclash https://github.com/vernesong/OpenClash.git;master' >> feeds.conf.default


# =========================================================
# iStore 官方 Feed
# =========================================================

grep -q 'src-git istore ' feeds.conf.default || \
echo 'src-git istore https://github.com/linkease/istore.git;main' >> feeds.conf.default


# =========================================================
# 删除旧的独立插件源码
# =========================================================

rm -rf "${HOME_PATH}/package/luci-app-v2ray-server"
rm -rf "${HOME_PATH}/package/luci-app-wechatpush"
rm -rf "${HOME_PATH}/package/luci-app-autoupdate"
rm -rf "${HOME_PATH}/package/luci-app-singbox-ui"
rm -rf "${HOME_PATH}/package/luci-app-bypass"


# =========================================================
# 添加 Bypass
#
# 原作者仓库已归档，使用现存 fork
# =========================================================

git clone -q --depth=1 \
    https://github.com/nuoooo/openwrt-bypass.git \
    /tmp/openwrt-bypass

if [ -d "/tmp/openwrt-bypass/luci-app-bypass" ]; then
    cp -Rf \
        "/tmp/openwrt-bypass/luci-app-bypass" \
        "${HOME_PATH}/package/luci-app-bypass"
fi

rm -rf /tmp/openwrt-bypass


# =========================================================
# 添加 V2Ray Server
#
# 来源：
# https://github.com/coolsnowwolf/luci
# =========================================================

git clone -q \
    --filter=blob:none \
    --no-checkout \
    https://github.com/coolsnowwolf/luci.git \
    /tmp/coolsnowwolf-luci

if [ -d "/tmp/coolsnowwolf-luci" ]; then

    cd /tmp/coolsnowwolf-luci || exit 1

    git sparse-checkout init --cone

    git sparse-checkout set \
        applications/luci-app-v2ray-server

    git checkout -q

    if [ -d "applications/luci-app-v2ray-server" ]; then
        cp -Rf \
            applications/luci-app-v2ray-server \
            "${HOME_PATH}/package/luci-app-v2ray-server"
    fi

fi

cd "${HOME_PATH}" || exit 1

rm -rf /tmp/coolsnowwolf-luci


# =========================================================
# 添加 微信推送
#
# 原作者：
# tty228/luci-app-wechatpush
# =========================================================

git clone -q --depth=1 \
    https://github.com/tty228/luci-app-wechatpush.git \
    "${HOME_PATH}/package/luci-app-wechatpush"


# =========================================================
# 添加 自动升级
#
# 原作者：
# 281677160/luci-app-autoupdate
# =========================================================

git clone -q --depth=1 \
    https://github.com/281677160/luci-app-autoupdate.git \
    "${HOME_PATH}/package/luci-app-autoupdate"


# =========================================================
# 添加 Sing-box UI
#
# 原作者：
# ang3el7z/luci-app-singbox-ui
# =========================================================

git clone -q --depth=1 \
    https://github.com/ang3el7z/luci-app-singbox-ui.git \
    "${HOME_PATH}/package/luci-app-singbox-ui"


# 后台IP设置
export Ipv4_ipaddr="192.168.2.99"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="OpenWrt"                # 修改主机名称为OpenWrt-123(填0为不作修改)

# 内核和系统分区大小(不是每个机型都可用)
export Kernel_partition_size="256"            # 内核分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般16,数值以MB计算，填0为不作修改),如果你不懂就填0
export Rootfs_partition_size="512"            # 系统分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般300左右,数值以MB计算，填0为不作修改),如果你不懂就填0

# 默认主题设置
export Mandatory_theme="argon"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="argon"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)

# 旁路由选项
export Gateway_Settings="192.168.2.1"                 # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
export DNS_Settings="192.168.2.1"                     # 旁路由设置 DNS(填入DNS，多个DNS要用空格分开)(填0为不作修改)
export Broadcast_Ipv4="255.255.255.255"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
export Disable_DHCP="1"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
export Disable_Bridge="1"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
export Create_Ipv6_Lan="1"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)

# IPV6、IPV4 选择
export Enable_IPV6_function="1"             # 编译IPV6固件(1为启用命令,填0为不作修改)(如果跟Create_Ipv6_Lan一起启用命令的话,Create_Ipv6_Lan命令会自动关闭)
export Enable_IPV4_function="0"             # 编译IPV4固件(1为启用命令,填0为不作修改)(如果跟Enable_IPV6_function一起启用命令的话,此命令会自动关闭)

# 替换OpenClash的源码(默认master分支)
export OpenClash_branch="1"                 # OpenClash的源码分别有【master分支】和【dev分支】(填0为关闭,填1为使用master分支,填2为使用dev分支,填入1或2的时候固件自动增加此插件)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="$(TZ=UTC-8 date "+%Y.%m.%d")"  # 个性签名,你想写啥就写啥，(填0为不作修改)

# 更换固件内核
export Replace_Kernel="0"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核x.x版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件和核心
export AdGuardHome_Core="0"                  # 编译固件时自动增加AdGuardHome插件和AdGuardHome插件核心,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不作修改)

# 开启NTFS格式盘挂载
export Automatic_Mount_Settings="1"          # 编译时加入开启NTFS格式盘挂载的所需依赖(1为启用命令,填0为不作修改)

# 去除网络共享(autosamba)
export Disable_autosamba="0"                 # 去掉源码默认自选的luci-app-samba或luci-app-samba4(1为启用命令,填0为不作修改)

# 其他
export Ttyd_account_free_login="1"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="1"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带此功能)(1为启用命令,填0为不作修改)
export Cancel_running="1"                    # 取消路由器每天跑分任务(个别源码本身不带此功能)(1为启用命令,填0为不作修改)


# 晶晨CPU系列打包固件设置(不懂请看说明)
export amlogic_model="s905d"
export amlogic_kernel="6.1.120_6.12.15"
export auto_kernel="true"
export rootfs_size="512/2560"
export kernel_usage="stable"


# 修改插件名字
grep -rl '"终端"' . | xargs -r sed -i 's?"终端"?"TTYD"?g'
grep -rl '"TTYD 终端"' . | xargs -r sed -i 's?"TTYD 终端"?"TTYD"?g'
grep -rl '"网络存储"' . | xargs -r sed -i 's?"网络存储"?"NAS"?g'
grep -rl '"实时流量监测"' . | xargs -r sed -i 's?"实时流量监测"?"流量"?g'
grep -rl '"KMS 服务器"' . | xargs -r sed -i 's?"KMS 服务器"?"KMS激活"?g'
grep -rl '"USB 打印服务器"' . | xargs -r sed -i 's?"USB 打印服务器"?"打印服务"?g'
grep -rl '"Web 管理"' . | xargs -r sed -i 's?"Web 管理"?"Web管理"?g'
grep -rl '"管理权"' . | xargs -r sed -i 's?"管理权"?"改密码"?g'
grep -rl '"带宽监控"' . | xargs -r sed -i 's?"带宽监控"?"监控"?g'


# =========================================================
# 编译前检查
# =========================================================

echo "========================================================="
echo "检查自定义插件"
echo "========================================================="

for PKG in \
    luci-app-bypass \
    luci-app-v2ray-server \
    luci-app-wechatpush \
    luci-app-autoupdate \
    luci-app-singbox-ui
do
    if [ -f "${HOME_PATH}/package/${PKG}/Makefile" ]; then
        echo "[OK] ${PKG}"
    else
        echo "[WARN] ${PKG} 未找到 Makefile"
    fi
done


# =========================================================
# 检查冲突包
# =========================================================

echo "========================================================="
echo "检查 mihomo / OAF 冲突包"
echo "========================================================="

find "${HOME_PATH}/package" -type f \
    \( -name Makefile -o -name Kconfig \) \
    -print0 2>/dev/null |
xargs -0 grep -IlE \
    'mihomo-alpha|mihomo-meta|kmod-oaf' \
    2>/dev/null || true


# =========================================================
# 检查 feeds
# =========================================================

echo "========================================================="
echo "当前 feeds.conf.default"
echo "========================================================="

grep -E \
    'Openwrt-Passwall|OpenClash|linkease/istore' \
    "${HOME_PATH}/feeds.conf.default" || true



# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
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

# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
cat >>$DELETE <<-EOF
EOF
