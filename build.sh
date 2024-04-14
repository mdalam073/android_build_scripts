#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \
# Initialize repo with specified manifest
repo init -u https://github.com/PixelExperience/manifest -b fourteen --depth=1 ;\

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b PixelExperience-14 .repo/local_manifests ;\

<!--- Device tree --->
<project path="device/xiaomi/tissot" name="mdalam073/android_device_xiaomi_tissot" remote="rem" revision="derp-14" clone-depth="1" />

# Sync the repositories
/opt/crave/resync.sh && \


# Set up build environment
source build/envsetup.sh && \

# Lunch configuration
lunch aosp_tissot-ap1a-userdebug ;\

croot ;\
mka bacon ; \
# echo "Date and time:" ; \

# Print out/build_date.txt
# cat out/build_date.txt; \

# Print SHA256
# sha256sum out/target/product/*/*.zip"

# Clean up
# rm -rf tissot/*



# Pull generated zip files
# crave pull out/target/product/*/*.zip

# Pull generated img files
# crave pull out/target/product/*/*.img

# Upload zips to Telegram
# telegram-upload --to sdreleases tissot/*.zip

#Upload to Github Releases
#curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
