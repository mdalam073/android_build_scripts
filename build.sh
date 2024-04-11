#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/PixelExperience/manifest -b fourteen --depth=1 --platform="auto,emulator,kvm"

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b PixelExperience-14 .repo/local_manifests

# Sync the repositories
/opt/crave/resync.sh

# Set up build environment
source build/envsetup.sh

# Lunch configuration
lunch aosp_tissot-userdebug

# Build the ROM
mka bacon

# Clean up (optional)
# rm -rf out/

# Additional commands you may uncomment as needed:
# Print build date
# echo "Date and time:"
# cat out/build_date.txt

# Print SHA256
# sha256sum out/target/product/*/*.zip

# Pull generated zip files (optional)
# crave pull out/target/product/*/*.zip

# Pull generated img files (optional)
# crave pull out/target/product/*/*.img

# Upload zips to Telegram (optional)
# telegram-upload --to sdreleases tissot/*.zip

# Upload to Github Releases (optional)
# curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh