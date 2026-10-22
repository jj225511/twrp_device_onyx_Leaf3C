#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from Leaf3C device
$(call inherit-product, device/onyx/Leaf3C/device.mk)

PRODUCT_DEVICE := Leaf3C
PRODUCT_NAME := twrp_Leaf3C
PRODUCT_BRAND := ONYX
PRODUCT_MODEL := BOOX Leaf3C
PRODUCT_MANUFACTURER := onyx

PRODUCT_GMS_CLIENTID_BASE := android-onyx

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="BOOX-user 11 RKQ1.210614.002 200 release-keys"

BUILD_FINGERPRINT := ONYX/BOOX/BOOX:11/RKQ1.210614.002/200:user/release-keys
