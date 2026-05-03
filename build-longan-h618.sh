#!/bin/bash

# Longan H618 Armbian 构建脚本
# 用于测试构建 Armbian 镜像

set -e

echo "=== Longan H618 Armbian 构建脚本 ==="
echo "开始构建 Armbian 镜像..."

# 检查是否在正确的目录
if [ ! -f "compile.sh" ]; then
    echo "错误：请在 Armbian 构建目录中运行此脚本"
    exit 1
fi

# 构建配置
BOARD="longan-h618"
BRANCH="current"
RELEASE="noble"
BUILD_DESKTOP="no"
BUILD_MINIMAL="yes"
KERNEL_CONFIGURE="no"

echo "构建配置："
echo "  板级: $BOARD"
echo "  内核分支: $BRANCH"
echo "  发行版: $RELEASE"
echo "  桌面环境: $BUILD_DESKTOP"
echo "  最小化构建: $BUILD_MINIMAL"
echo ""

# 开始构建
echo "开始构建 Armbian 镜像..."
./compile.sh build \
    BOARD=$BOARD \
    BRANCH=$BRANCH \
    RELEASE=$RELEASE \
    BUILD_DESKTOP=$BUILD_DESKTOP \
    BUILD_MINIMAL=$BUILD_MINIMAL \
    KERNEL_CONFIGURE=$KERNEL_CONFIGURE

echo "构建完成！"
echo "镜像文件位于 output/images/ 目录中"
