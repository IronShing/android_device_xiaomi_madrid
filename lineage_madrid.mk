#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from madrid device.
$(call inherit-product, device/xiaomi/madrid/device.mk)

## Device identifier
PRODUCT_DEVICE := madrid
PRODUCT_NAME := lineage_madrid
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := M154FF
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceProduct=madrid \
    SystemName=madrid \
    SystemDevice=madrid

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.product.marketname=Xiaomi 18 Pro Max

BUILD_FINGERPRINT := Xiaomi/madrid/madrid:17/CQ2A.260712.001-CP2A.260605.016/OS4.0.24.0.XEOCNXM:user/release-keys

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
