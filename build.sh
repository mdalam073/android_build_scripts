#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "
    # Clean and reset repo manually
    echo 'Cleaning and resetting repo...' && \
    rm -rf .repo/local_manifests && \
    rm -rf .repo/project-objects/* && \
    rm -rf .repo/projects/* && \
    rm -rf .repo/repo/ && \
    
    # Reinitialize repo with specified manifest
    repo init -u https://github.com/VoltageOS/manifest.git -b 14 --git-lfs --depth=1 && \
    
    # Clone local_manifests repository
    git clone https://github.com/mdalam073/local_manifest --depth 1 -b voltageos-14 .repo/local_manifests && \
    
    # Sync the repositories
    repo sync -j$(nproc) --force-sync && \ 
    
    # Set up build environment
    source build/envsetup.sh && \
    
    # Lunch configuration
    lunch voltage_tissot-ap1a-userdebug && \
    
    # Build
    croot && \
    mka bacon

    # Pull generated zip files
    crave pull out/target/product/*/*.zip"

    # Pull generated img files
    crave pull out/target/product/*/*.img

    # Upload zips to Telegram
    # telegram-upload --to sdreleases out/target/product/*/*.zip

    # Upload to Github Releases
    # curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
"

# Clean up build artifacts (if needed)
# rm -rf out/target/product/*