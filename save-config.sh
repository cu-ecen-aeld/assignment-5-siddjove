#!/bin/bash
# Script to save the modified configuration as modified_qemu_aarch64_virt_defconfig and linux kernel configuration.
# Author: Siddhant Jajoo.

cd `dirname $0`
source shared.sh

mkdir -p base_external/configs/

# Save current Buildroot config into our modified defconfig
make -C buildroot savedefconfig BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}

# Optionally also save linux kernel defconfig if using custom kernel config
if [ -e buildroot/.config ] && ls buildroot/output/build/linux-*/.config >/dev/null 2>&1; then
    if grep "BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE" buildroot/.config > /dev/null 2>&1; then
        echo "Saving linux defconfig"
        make -C buildroot linux-update-defconfig
    fi
fi
