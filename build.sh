#!/bin/bash

set -e

# Remove existing local_manifests (if needed)
rm -rf .repo/local_manifests

# Initialize repo with specified manifest for PixelExperience
repo init -u https://github.com/PixelExperience/manifest -b fourteen --depth=1 --platform="auto,emulator,kvm"

# Clone your local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b PixelExperience-14 .repo/local_manifests

# Sync the repositories
/opt/crave/resync.sh

# Set up build environment
source build/envsetup.sh

# Lunch configuration
lunch aosp_tissot-userdebug

# Build the ROM
mka bacon