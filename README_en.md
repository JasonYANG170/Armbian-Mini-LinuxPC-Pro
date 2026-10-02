[简体中文](README.md) | [English](README_en.md)

# Armbian Mini LinuxPC Pro - DSDZ-H618

Repackaged based on the official Armbian image and supports DSDZ-H618 development board (Allwinner H618).

## Supported hardware

![Mini-LinuxPC-Pro H618 handheld computer](docs/images/project-hardware.webp)

The image shows the supported hardware; the screen contents come from the hardware project's demonstration.

[Hardware project and image source](https://oshwhub.com/jasonyang17/mini-linuxpc-pro)

## Hardware information

- **SoC**: Allwinner H618 (ARM Cortex-A53, quad-core)
- **RAM**: 1GB/2GB LPDDR4
- **Storage**: 128GB eMMC
- **Network**: 1GbE (RTL8221B)
- **Display**: ST7789V SPI LCD (170x320)

## Quick start

### Download firmware

Download the latest firmware from the [Releases](https://github.com/JasonYANG170/Armbian-Mini-LinuxPC-Pro/releases) page.

### Flash

1. Use Rufus or balenaEtcher to write the firmware to the TF card
2. Insert the TF card into the development board
3. Connect to the serial port or SSH (the default IP is obtained from the router)
4. Default user: root, password: 1234

### Install to eMMC

```bash
armbian-install
```

## Build method

This project uses the **image repackaging** method and does not compile from source code:

```
官方 Armbian 镜像 → 下载 → 替换设备树/配置 → 重新打包 → 发布
```

### GitHub Actions automated builds

1. Fork this repository
2. Enter the Actions page
3. Select "Build Armbian for DSDZ-H618"
4. Click "Run workflow"

### Local build

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

## Directory structure

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

## License

Based on [Armbian](https://github.com/armbian/build) open source project.
