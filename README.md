# TWRP Device Tree — BOOX Leaf3C (onyx)

Unofficial TWRP device tree for the Onyx BOOX Leaf3C e-reader.

- SoC: Qualcomm SM662/SD662 (bengal), Android 11, VNDK 30
- A/B slots with **dedicated** recovery_a/recovery_b partitions (96 MiB) — not recovery-in-boot
- Virtual A/B + super (4 GiB) dynamic partitions
- /data: f2fs, FBE v2 + dm-default-key + wrappedkey_v0, keymaster 4.0/4.1
- E Ink panel 1264x1680 (300 dpi), frontlight via panel0-backlight

## Provenance

Ported from [dmayala/android_device_hisense_HLTE556N](https://github.com/dmayala/android_device_hisense_HLTE556N)
(Hisense A9 — same bengal platform, same partition scheme, same FBE config).
Device-specific values were measured from the device itself:

- kernel + recovery_dtbo: extracted from the device's own recovery_b (stock 4.2 firmware)
- fstab values: /vendor/etc/fstab.default
- prebuilt libs (libboot_control_qti, librecovery_updater, boot HAL impl, libion): from the stock recovery ramdisk

## Build

```
source build/envsetup.sh
lunch twrp_Leaf3C-eng
mka recoveryimage
```

Intended for the TWRP minimal manifest (twrp-12.1).

## Flashing

TWRP goes into the recovery_a/recovery_b partition — the boot partition
(Magisk) is untouched. The stock slot keeps booting normally whatever
happens to recovery.
