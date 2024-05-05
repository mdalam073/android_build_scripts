#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \
# Initialize repo with specified manifest
repo init -u https://github.com/VoltageOS/manifest.git -b 14 --git-lfs --depth=1


# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b voltageos-14 .repo/local_manifests && \

# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \  

# Run resync script
/opt/crave/resync.sh && \  

# Set up build environment
. build/envsetup.sh && \

# Lunch configuration
brunch tissot && \

# Clean up
rm -rf tissot/*"
