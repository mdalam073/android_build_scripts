#!/bin/bash

set -e

# Initialize repo with the first manifest
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
crave run --no-patch -- "
    # Remove existing local_manifests
    rm -rf .repo/local_manifests && \
    # Initialize repo with the SuperiorOS manifest
    repo init -u https://github.com/SuperiorOS/manifest -b fourteen --git-lfs --depth=1 && \
    # Clone local_manifests repository
    git clone https://github.com/mdalam073/local_manifest --depth 1 -b superior-tissot .repo/local_manifests && \
    # Sync the repositories
    /opt/crave/resync.sh && \
    # Set up build environment
    source build/envsetup.sh && \
    # Lunch configuration
    lunch superior_tissot-ap1a-userdebug && \
    # Change to the root directory
    croot && \
    # Install and pull Git LFS files
    repo forall -c 'git lfs install && git lfs pull && git lfs checkout' && \
    # Start the build process
    m bacon
"

# Clean up (optional)
# rm -rf tissot/*

# Pull generated zip files (optional)
# crave pull out/target/product/*/*.zip

# Pull generated img files (optional)
# crave pull out/target/product/*/*.img

# Upload zips to Telegram (optional)
# telegram-upload --to sdreleases tissot/*.zip

# Upload to Github Releases (optional)
# curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh