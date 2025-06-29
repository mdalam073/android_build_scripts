#!/bin/bash

rm -rf .repo/local_manifests/
rm -rf device/xiaomi
rm -rf vendor/xiaomi
rm -rf prebuilts/clang/host/linux-x86
# Rom source repo
repo init -u https://github.com/AxionAOSP/android.git -b lineage-22.2 --git-lfs

echo "=================="
echo "Repo init success"
echo "=================="


# Clone All Repositories
git clone https://github.com/kdrag0n/proton-clang --depth 1  prebuilts/clang/host/linux-x86/clang-proton
git clone https://github.com/mdalam073/device_xiaomi_tissot_e -b Axion --depth 1 device/xiaomi/tissot
git clone https://github.com/mdalam073/device_xiaomi_msm8953-common_e -b vic --depth 1 device/xiaomi/msm8953-common
git clone https://https://github.com/mdalam073/vendor_xiaomi_tissot -b vic --depth 1 vendor/xiaomi/tissot
git clone https://https://github.com/mdalam073/vendor_xiaomi_msm8953-common_e -b vic --depth 1 vendor/xiaomi/msm8953-common
git clone https://https://github.com/mdalam073/kernel_xiaomi_tissot -b vic --depth 1 kernel/xiaomi/msm8953

echo "============================"
echo "All Repositrories Cloned Successfuly"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============= Repo Sync Done =============="

#fix for d2tw
rm -rf frameworks/base
git clone https://github.com/dain09/android_frameworks_base frameworks/base
echo "============= dt2w fixed =============="
echo ">>> Applying dt2w patch..."

cd frameworks/base || { echo "frameworks/base not found!"; exit 1; }

if curl -sL https://github.com/dain09/android_frameworks_base/commit/a4e27665c44301a7685abe377082b26d271f984f.patch | patch -p1 --dry-run > /dev/null; then
    curl -sL https://github.com/dain09/android_frameworks_base/commit/a4e27665c44301a7685abe377082b26d271f984f.patch | patch -p1
    echo "✓ dt2w patch applied successfully."
else
    echo "✓ dt2w patch already applied or conflicts exist."
fi

cd -

# Export
export BUILD_USERNAME=Dain
export BUILD_HOSTNAME=crave
export TZ=Africa/Egypt
echo "======= Export Done ======"

# for vanilla 
# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

#sign build 
gk -s

# Lunch
axion RMX1971 userdebug va
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
ax -br

#for vanilla & gapps
rm -rf out/target/product/vanilla
rm -rf out/target/product/gapps
cd out/target/product && mv RMX1971 vanilla && cd ../../.. &&

# Set up build environment gapps
source build/envsetup.sh
echo "====== Envsetup Done ======="

#sign build 
gk -s

# Lunch
axion RMX1971 userdebug gms core
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
ax -br

cd out/target/product && mv RMX1971 gapps && cd ../../.."
