# Android Mirror Scripts 

This repository is intended to be used for automated setup and sync of AOSP/LineageOS/CalyxOS mirrors.

It is designed to save as much space as possible while keeping the majority of repositories synced. This is done by linking LineageOS/CalyxOS git alternates to AOSP mirror and linking all kernels to upstream linux/linux-stable, google common kernel and QCOM kernel git alternates. You can read through the scripts for more info.

Setting the mirrors up:
```
mkdir -p /mnt/mirrors/scripts
cd /mnt/mirrors/scripts
repo init -u https://github.com/mikeNG/android-mirror-scripts
repo sync
scripts/setup-mirrors.sh
scripts/setup-kernel-mirror.sh
scripts/setup-calyx-weblate-alternates.sh

```

Once the mirrors are set up you can then run `./sync.sh` to sync all the mirrors.

