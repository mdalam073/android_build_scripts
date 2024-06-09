#!/bin/bash

set -e

LOG_FILE="build.log"
REPO_URL="https://github.com/SuperiorOS/manifest"
BRANCH="fourteen"
LOCAL_MANIFEST_URL="https://github.com/mdalam073/local_manifest"
LOCAL_MANIFEST_BRANCH="superior-tissot"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

log "Starting the build script"

# Initialize repo with the first manifest
log "Initializing repo with the PixelOS manifest"
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
log "Running Crave environment setup"
crave run --no-patch -- "
    set -e
    
    LOG_FILE='/tmp/src/android/build.log'
    
    log() {
        echo \"\$(date +'%Y-%m-%d %H:%M:%S') - \$1\" | tee -a \$LOG_FILE
    }

    cd /tmp/src/android

    log 'Initializing repo with the SuperiorOS manifest'
    repo init -u $REPO_URL -b $BRANCH --git-lfs --depth=1

    clean_and_reset_repos() {
        repo forall -c 'git clean -fdx && git reset --hard'
    }

    sync_specific_repo() {
        local repo_path=\$1
        repo sync -c --force-sync --no-clone-bundle --no-tags --prune --fail-fast \$repo_path
    }

    log 'Cleaning and resetting repos'
    clean_and_reset_repos

    log 'Initial sync with verbose output for debugging'
    repo sync -c -j1 --force-sync --no-clone-bundle --no-tags --prune --fetch-submodules --fail-fast --verbose || true

    log 'Syncing specific repos'
    sync_specific_repo external/rust/cxx/tools/buck/prelude
    sync_specific_repo art

    log 'Cleaning and resetting repos again'
    clean_and_reset_repos

    log 'Removing existing local_manifests and repo objects to avoid conflicts'
    rm -rf .repo/local_manifests
    rm -rf .repo/project-objects/*
    rm -rf .repo/projects/*
    rm -rf .repo/repo/

    log 'Reinitializing repo'
    repo init -u $REPO_URL -b $BRANCH --git-lfs --depth=1

    log 'Cloning local_manifests repository'
    git clone $LOCAL_MANIFEST_URL --depth 1 -b $LOCAL_MANIFEST_BRANCH .repo/local_manifests

    log 'Cleaning and resetting repos before final sync'
    clean_and_reset_repos

    log 'Final sync with verbose output for debugging and fail fast'
    repo sync -c -j1 --force-sync --no-clone-bundle --no-tags --prune --fetch-submodules --fail-fast --verbose

    if [ ! -f build/make/core/main.mk ]; then
        log 'Error: build/make/core/main.mk not found. Sync may have failed.'
        exit 1
    fi

    log 'Cleaning previous build artifacts'
    make clean

    log 'Setting up build environment'
    source build/envsetup.sh

    if ! lunch superior_tissot-userdebug; then
        log 'Invalid lunch combo: superior_tissot-userdebug'
        exit 1
    fi

    export TARGET_RELEASE=ap1a

    log 'Changing to root directory'
    croot

    log 'Installing and pulling Git LFS files'
    repo forall -c 'git lfs install && git lfs pull && git lfs checkout'

    log 'Starting the build process with soong and ninja'
    build/soong/soong_ui.bash --make-mode bacon
"

log "Build script completed"
