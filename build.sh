#!/bin/bash

set -e

# Remove existing local_manifests
crave run --no-patch -- "
rm -rf .repo/local_manifests &&

# Initialize repo with specified manifest
repo init -u https://github.com/LineageOS/android.git -b lineage-22.2 --git-lfs &&

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b a15 .repo/local_manifests &&

# Sync the repositories
/opt/crave/resync.sh &&

# Set up build environment
. build/envsetup.sh &&

# Lunch configuration
lunch lineage_tissot-ap4a-eng &&

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
