#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
crave run --no-patch -- "
# Remove existing local_manifests
rm -rf .repo/local_manifests && \
# Initialize repo with specified manifest
repo init -u https://github.com/SuperiorOS/manifest.git -b fourteen --git-lfs --depth=1 && \
# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b superior-tissot .repo/local_manifests && \
# Sync the repositories
/opt/crave/resync.sh && \
repo sync --force-sync && \
# Set up build environment
source build/envsetup.sh && \
# Clean the build environment
make clean && \
# Lunch configuration
lunch superior_tissot-userdebug && \
# Change root to build environment
croot && \
# Build the target
m bacon && \
# Print SHA256 checksums of all .zip files in the output directory
sha256sum out/target/product/*/*.zip && \
# Pull generated .zip files
crave pull out/target/product/*/*.zip && \
# Pull generated .img files
crave pull out/target/product/*/*.img && \
# Upload to GitHub Releases using a script from the Releases repository
curl -sf https://raw.githubusercontent.com/mdalam073/Releases/main/headless.sh | sh
"
