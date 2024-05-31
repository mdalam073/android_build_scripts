#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs --depth=1

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \

# Initialize repo with specified manifest
repo init -u https://github.com/ProjectInfinity-X/manifest -b QPR2 --git-lfs --depth=1 ;\

# Clone local_manifests repository
git clone https://github.com/mdalam073/local_manifest --depth 1 -b infinity-x-tissot .repo/local_manifests ;\

# Sync the repositories
/opt/crave/resync.sh && \ 


# Set up build environment
. build/envsetup.sh && \

# Lunch configuration
lunch infinity_tissot-ap1a-userdebug ;\

croot ;\
mka bacon ; \
# echo "Date and time:" ;\

# Print out/build_date.txt
# cat out/build_date.txt ;\

# Print SHA256
# sha256sum out/target/product/*/*.zip" ;\

# Pull generated zip files
# crave pull out/target/product/*/*.zip ;\

# Pull generated img files
# crave pull out/target/product/*/*.img ;\

#Upload to Github Releases
#curl -sf https://raw.githubusercontent.com/mdalam073/Releases/main/headless.sh | sh 
