 # Allwinner H618 quad core 1GB/2GB RAM SoC USB-C 16G/32G Emmc
BOARD_NAME="DSDZ H618"
BOARDFAMILY="sun50iw9"
BOOTCONFIG="dsdz-h618_defconfig"
BOOT_LOGO="desktop"
SERIALCON="ttyAS0"
KERNEL_TARGET="current,edge"
KERNEL_TEST_TARGET="current,edge" # in case different then kernel target
FORCE_BOOTSCRIPT_UPDATE="yes"
BOOTBRANCH_BOARD="tag:v2024.01"
BOOTPATCHDIR="v2024.01"
BOARD_MAINTAINER="Mori"
enable_extension "radxa-aic8800"
AIC8800_TYPE="sdio"
SERIALCON="ttyS0"

function post_family_tweaks__dsdz-h618() {
	display_alert "Applying wifi firmware"

	cp -rf $SDCARD/lib/firmware/aic8800_fw/SDIO/aic8800/* $SDCARD/lib/firmware/aic8800_fw/SDIO/aic8800D80/
	
	cp -rf ${SRC}/myfile/overlay_rootfs/* $SDCARD/

	
	#cp -rf ${SRC}/myfile/armbian-firstlogin $SDCARD/usr/lib/armbian/armbian-firstlogin
	
	#cp -rf ${SRC}/myfile/ds-emmc-tool $SDCARD/usr/local/bin/ds-emmc-tool
	
	#chmod 777 $SDCARD/usr/local/bin/ds-emmc-tool
	
	#cp -rf ${SRC}/myfile/asound.state $SDCARD/var/lib/alsa/asound.state
	
	#cp -rf ${SRC}/myfile/test.wav $SDCARD/root/test.wav
	
	

}
