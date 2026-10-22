#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/onyx/Leaf3C

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-impl.recovery \
    android.hardware.boot@1.0-service

PRODUCT_PACKAGES += \
    bootctrl.bengal \
    bootctrl.bengal.recovery

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

# BCB-clearing hook for "Reboot System" from the TWRP UI (stock Virtual A/B
# message at misc offset 32768 must survive; only the 2048-byte BCB is
# zeroed). Shell script, so PRODUCT_COPY_FILES is fine here.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/system/bin/rebootsystem.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/rebootsystem.sh

# libion: required by the vendor keymaster HAL, NOT in TWRP's ramdisk by
# default. Shipped as a plain file under recovery/root/system/lib64/ (from
# the device's own stock recovery ramdisk) — recovery/root/ is copied
# verbatim, so no build rule and no ELF-collision with AOSP's module.
#
# Prebuilt libs shipped from the device's own stock recovery ramdisk (same
# path layout: system/lib64/):
#   libboot_control_qti.so / librecovery_updater.so /
#   hw/android.hardware.boot@1.0-impl-1.1-qti.so
