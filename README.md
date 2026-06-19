# Armbian Mini LinuxPC Pro

基于 Armbian 的 DSDZ-H618 定制固件，支持 ST7789 SPI 屏幕。

## 硬件规格

- SoC: Allwinner H618 (四核 Cortex-A53)
- RAM: 1GB/2GB DDR4
- 存储: 16GB/32GB eMMC
- 屏幕: ST7789 170x320 SPI LCD
- 网络: 千兆以太网
- WiFi: AIC8800 (SDIO)

## 编译方法

### GitHub Actions 自动编译

1. Fork 本仓库
2. 进入 Actions 页面
3. 选择 "Build Armbian for DSDZ-H618"
4. 点击 "Run workflow"
5. 选择构建类型（minimal 或 desktop）
6. 等待构建完成，下载固件

### 本地编译

```bash
# 克隆仓库
git clone https://github.com/JasonYANG170/Armbian-Mini-LinuxPC-Pro.git
cd Armbian-Mini-LinuxPC-Pro

# 编译最小固件
./compile.sh build BOARD=dsdz-h618 BRANCH=current BUILD_DESKTOP=no BUILD_MINIMAL=yes KERNEL_CONFIGURE=no RELEASE=jammy

# 编译桌面固件（GNOME）
./compile.sh build BOARD=dsdz-h618 BRANCH=current BUILD_DESKTOP=yes BUILD_MINIMAL=no DESKTOP_APPGROUPS_SELECTED='browsers multimedia' DESKTOP_ENVIRONMENT=gnome DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base KERNEL_CONFIGURE=no RELEASE=jammy
```

## 自定义配置

### 板级配置
`config/boards/dsdz-h618.csc`

### 设备树
- 板级: `myfile/sun50i-h618-dsdz-h618.dts`
- 芯片: `myfile/sun50i-h616.dtsi`

### 内核补丁
`patch/kernel/archive/sunxi-6.6/patches.armbian/`

### 自定义脚本
`userpatches/customize-image.sh`

## ST7789 屏幕配置

设备树中已配置 ST7789 SPI 屏幕：
- SPI1 总线
- 分辨率: 170x320
- 旋转: 90度
- GPIO:
  - Reset: PH8
  - DC: PH4
  - LED: PH9

## 许可证

基于 Armbian 开源项目，遵循 GPL-2.0 许可证。
