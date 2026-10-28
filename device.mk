#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Stage 1 bring-up: LineageOS builds system, system_ext and product only.
# vendor, odm, vendor_dlkm, system_dlkm, mi_ext and the whole boot chain
# (boot/init_boot/vendor_boot/dtbo) stay stock HyperOS 4 (OS4.0.24.0.XEOCNXM),
# repacked into super by scripts/build_super.sh. Same approach as NX809J.

# Virtual A/B (stock super: virtual_ab_device, 3 metadata slots)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

# Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Dalvik heap (16 GB RAM class)
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Generic ramdisk (init_boot)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Shipping API: stock is HyperOS 4 on Android 17, board API 202604
BOARD_SHIPPING_API_LEVEL := 202604
PRODUCT_SHIPPING_API_LEVEL := 37

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
