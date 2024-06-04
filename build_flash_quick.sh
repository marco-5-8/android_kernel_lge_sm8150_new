#!/bin/bash

echo
echo "Issue Build Commands"
echo

export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=~/toolchains/clang/bin
export PATH=${CLANG_PATH}:${PATH}
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

echo
echo "Set DEFCONFIG"
echo 
make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out vendor/dragon_flash_defconfig

echo
echo "Build The Good Stuff"
echo 

make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out -j24
# Copy the current Image.gz-dtb to history with incremented name
history_dir=./release/Dragon/history
mkdir -p $history_dir
current_file=./release/Dragon/Image.gz-dtb
if [ -f "$current_file" ]; then
    n=$(ls $history_dir | grep -oP '^Image\K\d+(?=\.gz-dtb$)' | sort -nr | head -n1)
    n=$((n + 1))
    cp -f "$current_file" "$history_dir/Image${n}.gz-dtb"
fi

# Copy the new build to the release directory
cp -f ./out/arch/arm64/boot/Image.gz-dtb ./release/Dragon/Image.gz-dtb