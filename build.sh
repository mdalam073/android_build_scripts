#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "
rm -rf .repo/local_manifests &&

# Initialize repo with specified manifest
repo init -u https://github.com/VoltageOS/manifest -b 14 --git-lfs --depth=1 &&

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b voltageos-14 .repo/local_manifests &&

# Sync the repositories
/opt/crave/resync.sh &&

# Clean the build output directory to avoid conflicts
rm -rf out/* &&

# Remove any leftover build files from previous builds
find . -name '*.ninja' -exec rm -rf {} + &&
find . -name '*.o' -exec rm -rf {} + &&
find . -name '*.so' -exec rm -rf {} + &&
find . -name '*.a' -exec rm -rf {} + &&

# Set up build environment
source build/envsetup.sh &&

# Lunch configuration
lunch voltage_tissot-ap2a-userdebug &&

# Build
croot &&
mka bacon
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
