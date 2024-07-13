#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
crave run --no-patch -- "
    # Clean up local manifests and prebuilts
    rm -rf .repo/local_manifests &&
    rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git &&
    rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git &&

    # Initialize repo with specified manifest
    repo init -u https://github.com/PixelOS-AOSP/manifest.git -b fourteen --git-lfs --depth=1 &&

    # Clone local_manifests repository
    git clone https://github.com/mdalam073/local_manifest --depth 1 -b pixelos .repo/local_manifests &&

    # Sync the repositories
    /opt/crave/resynctest.sh &&

    # Set up build environment
    . build/envsetup.sh &&

    # Lunch configuration
    lunch aosp_tissot-ap2a-userdebug &&

    # Change root to build environment
    croot &&

    # Build the target
    mka bacon
"
# Print SHA256 checksums of all .zip files in the output directory
sha256sum out/target/product/*/*.zip && \

# Pull generated .zip files
crave pull out/target/product/*/*.zip && \

# Pull generated .img files
crave pull out/target/product/*/*.img && \

# Upload to GitHub Releases using a script from the Releases repository
curl -sf https://raw.githubusercontent.com/mdalam073/Releases/main/headless.sh | sh
