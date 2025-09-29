#!/bin/bash

set -e

# Remove existing local_manifests
crave run --no-patch -- "
rm -rf .repo/local_manifests &&

# Initialize repo with specified manifest
repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs &&

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b a16 .repo/local_manifests &&

rm -rf prebuilts/clang/host/linux-x86 &&

# Sync the repositories
repo sync --force-sync &&

# Timekeep 
git clone --depth=1 --branch lineage-22.2 https://github.com/LineageOS/android_hardware_sony_timekeep hardware/sony/timekeep &&

# Set up build environment
. build/envsetup.sh &&

# Lunch configuration and build
brunch tissot"

# Pull generated zip files
crave pull out/target/product/*/*.zip

# Pull generated img files
crave pull out/target/product/*/*.img

# Upload zips to Telegram
# telegram-upload --to sdreleases out/target/product/*/*.zip
    
# Upload to Github Releases
# curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
# Clean up build artifacts (if needed)
# rm -rf out/target/product/*
