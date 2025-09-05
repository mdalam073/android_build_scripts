#!/bin/bash

set -e

# Remove existing local_manifests
crave run --no-patch -- "
rm -rf .repo/local_manifests &&

# Initialize repo with specified manifest
repo init --git-lfs -u https://gitlab.com/CalyxOS/platform_manifest -b android15-qpr2 &&

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b calyx .repo/local_manifests &&

# Sync the repositories
repo sync --force-sync &&

# Set up build environment
./calyx/scripts/xiaomi/device.sh tissot &&
. build/envsetup.sh &&

# Lunch configuration
breakfast tissot user &&

# Build
m
"

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
