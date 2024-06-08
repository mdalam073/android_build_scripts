#!/bin/bash

set -e

# Initialize repo with the first manifest
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
crave run --no-patch -- "
    cd /tmp/src/android

    # Function to clean and reset repositories
    clean_and_reset_repos() {
        repo forall -c 'git clean -fdx && git reset --hard'
    }

    # Function to sync specific repositories
    sync_specific_repo() {
        local repo_path=\$1
        repo sync -c --force-sync --no-clone-bundle --no-tags --prune --fail-fast \$repo_path
    }

    # Step 1: Initialize the repo with the SuperiorOS manifest
    repo init -u https://github.com/SuperiorOS/manifest.git -b fourteen --git-lfs

    # Step 2: Sync the entire repo with verbose output for debugging
    repo sync --force-sync --no-clone-bundle --no-tags --prune --fetch-submodules --verbose || true

    # Step 3: Clean and reset repositories if necessary
    clean_and_reset_repos

    # Handle specific problematic repositories
    sync_specific_repo external/rust/cxx/tools/buck/prelude
    sync_specific_repo art

    # Clean and reset again to ensure a clean state
    clean_and_reset_repos

    # Remove existing local_manifests and repo objects
    rm -rf .repo/local_manifests
    rm -rf .repo/project-objects/*
    rm -rf .repo/projects/*
    rm -rf .repo/repo/

    # Reinitialize repo
    repo init -u https://github.com/SuperiorOS/manifest.git -b fourteen --git-lfs

    # Clone local_manifests repository
    git clone https://github.com/mdalam073/local_manifest --depth 1 -b superior-tissot .repo/local_manifests

    # Clean untracked files before syncing
    clean_and_reset_repos

    # Sync the repositories with verbose output for debugging and fail fast
    repo sync --force-sync --no-clone-bundle --no-tags --prune --fetch-submodules --verbose

    # Ensure the 'build/make/core/main.mk' file exists
    if [ ! -f build/make/core/main.mk ]; then
        echo 'Error: build/make/core/main.mk not found. Sync may have failed.'
        exit 1
    fi

    # Step 4: Set up the build environment
    source build/envsetup.sh

    # Step 5: Configure the build for the specific device (replace 'tissot' with your device codename)
    lunch superior_tissot-userdebug

    # Step 6: Start the build process using make bacon
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
