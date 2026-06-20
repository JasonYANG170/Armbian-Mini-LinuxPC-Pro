# Armbian Mini LinuxPC Pro - DSDZ-H618

基于官方 Armbian 镜像重新打包，支持 DSDZ-H618 开发板（Allwinner H618）。

## 硬件信息

- **SoC**: Allwinner H618 (ARM Cortex-A53, 四核)
- **RAM**: 1GB/2GB LPDDR4
- **存储**: 128GB eMMC
- **网络**: 1GbE (RTL8221B)
- **显示**: ST7789V SPI LCD (170x320)

## 快速使用

### 下载固件

从 [Releases](https://github.com/JasonYANG170/Armbian-Mini-LinuxPC-Pro/releases) 页面下载最新固件。

### 刷机

1. 使用 Rufus 或 balenaEtcher 将固件写入 TF 卡
2. 插入 TF 卡到开发板
3. 连接串口或 SSH（默认 IP 从路由器获取）
4. 默认用户：root，密码：1234

### 安装到 eMMC

```bash
armbian-install
```

## 构建方式

本项目使用 **镜像重打包** 方式，不从源码编译：

```
官方 Armbian 镜像 → 下载 → 替换设备树/配置 → 重新打包 → 发布
```

### GitHub Actions 自动构建

1. Fork 本仓库
2. 进入 Actions 页面
3. 选择 "Build Armbian for DSDZ-H618"
4. 点击 "Run workflow"

### 本地构建

```bash
# 安装依赖
sudo apt-get install -y wget xz-utils device-tree-compiler

# 下载官方 Armbian 镜像
wget https://github.com/armbian/build/releases/download/v24.2.1/Armbian_24.2.1_Orangepi3_jammy_current_6.6.16.img.xz

# 解压
xz -d *.img.xz

# 挂载镜像
sudo losetup -fP --show *.img
# 假设是 /dev/loop0
sudo mount /dev/loop0p1 /mnt/boot
sudo mount /dev/loop0p2 /mnt/root

# 替换设备树
sudo cp build-armbian/armbian-files/platform-files/allwinner/bootfs/dtb/allwinner/sun50i-h618-dsdz-h618.dtb /mnt/boot/dtb/allwinner/

# 修改 armbianEnv.txt
sudo tee /mnt/boot/armbianEnv.txt << EOF
verbosity=1
bootlogo=false
overlay_prefix=sun50i-h616
fdtfile=allwinner/sun50i-h618-dsdz-h618.dtb
rootdev=UUID=$(sudo blkid -s UUID -o value /dev/loop0p2)
rootfstype=ext4
rootflags=commit=5,noatime
EOF

# 卸载
sudo umount /mnt/boot /mnt/root
sudo losetup -d /dev/loop0

# 压缩
xz -z *.img
```

## 目录结构

```
Armbian-Mini-LinuxPC-Pro/
├── build-armbian/
│   └── armbian-files/
│       ├── common-files/etc/model_database.conf
│       └── platform-files/allwinner/
│           ├── bootfs/dtb/allwinner/sun50i-h618-dsdz-h618.dtb
│           └── rootfs/
├── .github/workflows/build-armbian.yml
└── myfile/
    ├── sun50i-h618-dsdz-h618.dts
    └── sun50i-h616.dtsi
```

## 许可证

基于 [Armbian](https://github.com/armbian/build) 开源项目。
