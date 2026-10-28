# LineageOS 24.0 device tree: Xiaomi 18 Pro Max (`madrid`)

**Status: early bring-up, NOT booted yet.** The system images build (first clean build 2026-10-28). Nothing has been flashed on
hardware. Don't flash this on your daily phone.

| | |
|---|---|
| Device | Xiaomi 18 Pro Max (CN `M154FF`; Global `2611FPNFAG`) |
| SoC | Snapdragon 8 Elite Extreme Gen 6 (SM8975), board platform `art` |
| Kernel | stock GKI `6.18.21-android17-5` (prebuilt, Google `abogki` build) |
| Stock base | HyperOS 4 `OS4.0.24.0.XEOCNXM`, Android 17, board API 202604 |
| Target | LineageOS 24.0 (Android 17), release config `cp2a` |

## Approach (stage 1)
Xiaomi hasn't published kernel source for madrid yet, and LineageOS has no CAF support for the `art`
platform. So this tree builds only the **LineageOS userspace** (`system`, `system_ext`, `product`).
Everything else stays stock HyperOS 4:

- boot chain: `boot` (GKI), `init_boot`, `vendor_boot` (4K + 16K-page module ramdisks + recovery), `dtbo`
- `super`: stock `vendor`, `odm` (camera stack), `vendor_dlkm`, `system_dlkm`, `mi_ext`

The stock vendor is already Android 17 (built on `CP2A`), so it matches LineageOS 24.0 directly.

`hardware/qcom-caf/common` needs one patch that treats `art` as the UM 6.12 (sm8850) family for now
(`patches/`).

## Build
```
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs
mkdir -p .repo/local_manifests
curl -Lo .repo/local_manifests/madrid.xml \
  https://raw.githubusercontent.com/IronShing/android_device_xiaomi_madrid/lineage-24.0/manifest/madrid.xml
repo sync -c -j8
bash device/xiaomi/madrid/patches/apply-patches.sh
source build/envsetup.sh
lunch lineage_madrid-cp2a-userdebug
m systemimage systemextimage productimage
```
Then repack `super` with `scripts/build_super.sh` (`lpmake`): our system/system_ext/product plus the stock partitions from the
official fastboot ROM (`madrid_images_OS4.0.24.0.XEOCNXM_20261009.0000.00_17.0_cn_14998967e9.tgz`).
Virtual A/B, 3 metadata slots, group `qti_dynamic_partitions` 18779996160 bytes, super 18790481920 bytes.

## Roadmap
- [x] Stock firmware survey, tree skeleton, system-side build
- [ ] Offline vendor sepolicy CIL validation against our system policy
- [ ] First boot on hardware
- [ ] Display: stock composer3 is V5, LOS caf sm8850 display is V4
- [ ] Xiaomi features: touchfeature, displayfeature, fingerprint (Goodix udfps + FPC), rear display, haptics
- [ ] KernelSU GKI kernel built from AOSP `android17-6.18`

## Credits
- LineageOS
- [lolipuru](https://github.com/lolipuru): Xiaomi SM8850 LineageOS 24.0 trees, used as a reference
- [NekoWannn](https://github.com/NekoWannn/uefi-hongkong): 18 Pro (hongkong) firmware research
