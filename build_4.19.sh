#!/bin/bash

echo -e "\n[INFO]: here be the dragons...\n"

export KERNEL_ROOT="$(pwd)"
export ARCH=arm64
export KBUILD_BUILD_USER="-EvaLancer"

# Export toolchain paths
export PATH="${HOME}/toolchains/clang-r353983c/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/toolchains/clang-r353983c/lib64:${LD_LIBRARY_PATH}"
export BUILD_CROSS_COMPILE="${HOME}/toolchains/gcc/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"
export BUILD_CC="${HOME}/toolchains/clang-r353983c/bin/clang"

# Build options for the kernel
export BUILD_OPTIONS=(
    -C "${KERNEL_ROOT}"
    O="${KERNEL_ROOT}/out"
    -j"$(nproc)"
    ARCH=arm64
    CROSS_COMPILE="${BUILD_CROSS_COMPILE}"
    CC="${BUILD_CC}"
    CLANG_TRIPLE=aarch64-linux-gnu-
)

build_kernel(){
    make "${BUILD_OPTIONS[@]}" a14m_defconfig

    # Build the kernel
    make "${BUILD_OPTIONS[@]}" Image || exit 1

    cp "${KERNEL_ROOT}/out/arch/arm64/boot/Image" "${KERNEL_ROOT}/build"

    echo -e "\n[INFO]: BUILD FINISHED... good luck."
}
build_kernel
