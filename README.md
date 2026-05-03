# Armbian for Longan H618

基于 [Armbian Build Framework](https://github.com/armbian/build) 为 Longan H618 开发板构建的系统镜像。

## 硬件规格

| 项目 | 规格 |
|------|------|
| SoC | Allwinner H618 (sun50iw9) |
| CPU | Cortex-A53 四核 |
| 内存 | 2GB DDR3 |
| 显示 | ST7789V SPI LCD (170x320) + HDMI |
| 网络 | GMAC1 RMII 以太网 |
| 存储 | SD卡 + eMMC |
| WiFi/BT | UWE5622 SDIO |
| USB | USB 2.0/3.0 x4 + OTG |
| RTC | PCF8563 (I2C1) |
| 红外 | IR 接收器 (PH10) |

## 快速开始

### 下载镜像

从 [Releases](https://github.com/JasonYANG170/armbian-longan-h618/releases) 页面下载最新镜像。

### 烧录到 SD 卡

```bash
sudo dd if=Armbian-*.img of=/dev/sdX bs=1M status=progress
sync
```

### 首次启动

1. 插入 SD 卡到 Longan H618 开发板
2. 连接串口 (UART0, 115200 baud)
3. 上电，等待系统初始化
4. 默认用户: `root` / 密码: `1234`

## 设备树配置

设备树文件位于 `patch/kernel/archive/sunxi-6.12/dt/sun50i-h618-longan.dts`。

### ST7789V 显示屏

```
SPI1 引脚:
- SCLK: PH6
- MOSI: PH7
- CS:   PH5
- DC:   PH4
- RST:  PH8
- LED:  PH9
```

### GMAC1 以太网

RMII 模式，使用 PA0-PA9 引脚。

### I2C1 (PCF8563 RTC)

- SDA: PI5
- SCL: PI6

## 自动构建

每次推送到 `main` 分支时，GitHub Actions 会自动构建镜像并发布到 Releases。

### 手动触发构建

在 [Actions](https://github.com/JasonYANG170/armbian-longan-h618/actions) 页面点击 "Run workflow"，可选择:
- **release**: noble / bookworm / trixie
- **desktop**: 是否构建桌面版
- **branch**: current / edge

## 目录结构

```
.
├── config/
│   └── boards/
│       └── longan-h618.conf      # 板级配置
├── patch/
│   ├── kernel/
│   │   └── archive/
│   │       └── sunxi-6.12/
│   │           └── dt/
│   │               └── sun50i-h618-longan.dts  # 设备树
│   └── u-boot/
│       └── v2026.01/              # U-Boot 补丁
├── userpatches/                   # 用户补丁目录
├── .github/
│   └── workflows/
│       └── build.yml              # CI/CD 配置
└── README.md
```

## 自定义构建

### 安装依赖

```bash
sudo apt install git bc lzop flex bison libssl-dev \
  libncurses-dev dos2unix u-boot-tools device-tree-compiler \
  ccache gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
```

### 克隆 Armbian 构建框架

```bash
git clone https://github.com/armbian/build.git
cd build
```

### 应用板级配置

```bash
cp -r ../config/boards/longan-h618.conf config/boards/
cp -r ../patch/kernel/archive/sunxi-6.12/dt/ patch/kernel/archive/sunxi-6.12/
```

### 构建

```bash
sudo ./compile.sh build \
  BOARD=longan-h618 \
  BRANCH=current \
  RELEASE=noble \
  BUILD_DESKTOP=no \
  BUILD_MINIMAL=yes
```

## 许可证

本项目基于 GPL-2.0 许可证。

## 致谢

- [Armbian](https://www.armbian.com/) - ARM Linux 构建框架
- [Allwinner](https://www.allwinnertech.com/) - SoC 厂商
- [sunxi](https://linux-sunxi.org/) - Allwinner Linux 社区