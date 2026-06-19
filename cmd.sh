
sudo ./compile.sh build BOARD=dsdz-h618 BRANCH=current

#编译gnome桌面ubuntu22.04
./compile.sh build BOARD=dsdz-h618 BRANCH=current BUILD_DESKTOP=yes BUILD_MINIMAL=no DESKTOP_APPGROUPS_SELECTED='browsers multimedia' DESKTOP_ENVIRONMENT=gnome DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base KERNEL_CONFIGURE=yes RELEASE=jammy 

#最小功能编译
./compile.sh build BOARD=dsdz-h618 BRANCH=current BUILD_DESKTOP=no BUILD_MINIMAL=yes KERNEL_CONFIGURE=yes RELEASE=jammy


KERNEL_ONLY=no \
KERNEL_CONFIGURE=no \
IGNORE_UPDATES=yes \
EXTERNAL=yes

#构建配置
/root/build-dsdz-h618/config/boards/dsdz-h618.csc


#只烧录u-boot
dd if=u-boot-sunxi-with-spl.bin of=/dev/sdc bs=1024 seek=8 conv=fsync


#修改U-BOOT配置

root@dsdz-virtual-machine:~/build-dsdz-h618/cache/sources/u-boot-worktree/u-boot/v2024.01# make dsdz-h618_defconfig
root@dsdz-virtual-machine:~/build-dsdz-h618/cache/sources/u-boot-worktree/u-boot/v2024.01# make menuconfig ARCH=arm64
root@dsdz-virtual-machine:~/build-dsdz-h618/cache/sources/u-boot-worktree/u-boot/v2024.01# make CROSS_COMPILE=aarch64-linux-gnu-


#u-boot补丁目录
/root/build-dsdz-h618/patch/u-boot/v2024.01/board_dsdz-h618


#u-boot源码目录
/root/build-dsdz-h618/cache/sources/u-boot-worktree/u-boot/v2024.01

#内核补丁目录
/root/build-dsdz-h618/patch/kernel/archive/sunxi-6.6/patches.armbian/




#WIFI模块固件路径
/usr/lib/firmware/aic8800_fw/SDIO/aic8800D80/



#将/dev/mmcblk0的u-boot-sunxi-with-spl.bin复制到/dev/mmcblk2

start=$(cat /sys/block/mmcblk0/mmcblk0p1/start)

umount /dev/mmcblk2* 2>/dev/null

dd if=/dev/mmcblk0 of=/dev/mmcblk2 bs=512 skip=16 seek=16 count=$((start-16)) conv=fsync

sync



# 调度/抢占模式
CONFIG_PREEMPT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_RT=y

# RCU 相关
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_RCU_BOOST=y  

CONFIG_HIGH_RES_TIMERS=y 
CONFIG_HZ_1000=y  
CONFIG_NO_HZ_COMMON=y
CONFIG_NO_HZ_IDLE=y