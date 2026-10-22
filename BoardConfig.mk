#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# BOOX Leaf3C — TWRP device tree
#
# Ported from dmayala/android_device_hisense_HLTE556N (Hisense A9) — same
# Qualcomm bengal (SM662/SD662) platform, same dedicated recovery_a/b layout,
# same Virtual A/B + super, same f2fs/FBE data scheme. All [MEASURED] values
# below were read directly from the device: boot/recovery image headers,
# /dev/block/by-name, vendor fstab (/vendor/etc/fstab.default) and
# prop.default.
#

DEVICE_PATH := device/onyx/Leaf3C

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# A/B — Virtual A/B (ro.virtual_ab.enabled=true) [MEASURED]
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    system \
    system_ext \
    product \
    vendor

# [MEASURED] Dedicated recovery_a/recovery_b partitions (96 MiB each).
# NOT recovery-in-boot. Flashing TWRP to recovery_b leaves boot (Magisk)
# untouched — ideal rescue-slot arrangement.
BOARD_USES_RECOVERY_AS_BOOT := false

# Architecture [MEASURED from prop.default]
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a9

# APEX
OVERRIDE_TARGET_FLATTEN_APEX := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := bengal
TARGET_NO_BOOTLOADER := true

# Display [MEASURED: wm size 1264x1680, density 300]
TARGET_SCREEN_DENSITY := 300

# Kernel [MEASURED from recovery_b image header]
#   header_version 2, page_size 4096, base 0x0,
#   kernel 0x8000 (gzip Image), ramdisk 0x1000000, tags 0x100
BOARD_BOOT_HEADER_VERSION := 2
BOARD_BOOTIMG_HEADER_VERSION := $(BOARD_BOOT_HEADER_VERSION)
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
# androidboot.dynamic_partitions=true is required for `adb reboot fastboot`
# to reach fastbootd (see Hisense A9 tree notes: without it, init reroutes
# reboot,fastboot to the bootloader).
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0x4a90000 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048 loop.max_part=7 buildvariant=user androidboot.dynamic_partitions=true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
# [MEASURED] Stock kernel segment is a gzip-compressed arm64 Image, no
# appended dtb (bootloader takes the DTB from the dtbo partition).
BOARD_KERNEL_IMAGE_NAME := Image.gz

# Kernel - prebuilt [MEASURED]
# kernel + recovery_dtbo + dtb extracted from the DEVICE's own recovery_b.
# Stock recovery_b layout (header v2): kernel (gzip Image, 41300047) →
# ramdisk → recovery_dtbo (905996, mkdtimg dt_table d7b7ab1e) → dtb
# (658721, d00dfeed). mkbootimg REQUIRES a non-empty --dtb for header v2
# (fails with "DTB image must not be empty" otherwise).
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_MKBOOTIMG_ARGS += --recovery_dtbo $(DEVICE_PATH)/prebuilt/recovery_dtbo.img
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
endif

# Partitions [MEASURED]
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296     # 96 MiB
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 100663296 # 96 MiB
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Metadata partition is present and required (dm-default-key lives here)
BOARD_USES_METADATA_PARTITION := true

# Dynamic partitions [MEASURED]
#   super: 4294967296 bytes (4 GiB, blockdev --getsize64)
BOARD_SUPER_PARTITION_SIZE := 4294967296
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 2143289344 # (super / 2) - 4 MiB

# Platform
TARGET_BOARD_PLATFORM := bengal

# Recovery [MEASURED: ro.minui.pixel_format=RGBX_8888]
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USES_MKE2FS := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Hack: prevent anti rollback
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 12.1.0
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)

# TWRP Configuration
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_INPUT_BLACKLIST := "hbtp_vm"

# Never blank the panel (E Ink: a blanked panel is indistinguishable from a
# frozen one because the last frame persists).
TW_NO_SCREEN_BLANK := true
TW_NO_SCREEN_TIMEOUT := true
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_NTFS_3G := true

# Frontlight [MEASURED from stock init.recovery.qcom.rc]
TW_BRIGHTNESS_PATH := /sys/class/backlight/panel0-backlight/brightness
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 200

# Crypto / /data decryption.
# [MEASURED] /vendor/etc/fstab.default /data line is byte-identical to the
# Hisense A9's: FBE v2, dm-default-key metadata encryption, wrappedkey_v0,
# keydirectory=/metadata/vold/metadata_encryption. keymaster 4.0 + 4.1
# service binaries both present in /vendor/bin/hw.
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_RESETPROP := true

# E Ink framebuffer handling (single buffer + exact line length; same
# Qualcomm fbdev stack as the A9, where both flags were required).
RECOVERY_GRAPHICS_FORCE_SINGLE_BUFFER := true
RECOVERY_GRAPHICS_FORCE_USE_LINELENGTH := true
