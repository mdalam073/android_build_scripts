#!/bin/bash

set -e

# Remove existing local_manifests
crave run --no-patch -- "
rm -rf .repo/local_manifests &&

# Initialize repo with specified manifest
repo init -u https://github.com/Project-Mist-OS/manifest -b 15 --git-lfs &&

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b Mist-15 .repo/local_manifests &&

# Sync the repositories
repo sync --force-sync &&

# Set up build environment
. build/envsetup.sh &&

# Lunch configuration
mistify tissot user &&

# Build
croot &&
mist b
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
