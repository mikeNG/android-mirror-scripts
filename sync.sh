#!/usr/bin/env bash

MIRROR_ROOT=${MIRROR_ROOT:=/mnt/mirrors}

# Sync the scripts and required manifests
pushd ${MIRROR_ROOT}/scripts
cd .repo/repo
git pull origin stable
cd ../../

repo sync -j64 -vv --fail-fast

scripts/lineage-metadata-regen.sh
scripts/calyx-metadata-regen.sh
popd

# Sync linux and linux-stable kernels
pushd ${MIRROR_ROOT}/kernel/linux
cd .repo/repo
git pull origin stable
cd ../../

repo sync -vv --fail-fast torvalds/linux
repo sync -vv --fail-fast stable/linux
popd

# Sync google kernels
pushd ${MIRROR_ROOT}/kernel/aosp
cd .repo/repo
git pull origin stable
cd ../../

repo sync -vv --fail-fast kernel/common

repo sync -j64 -vv --fail-fast
popd

# Sync qcom kernels
pushd ${MIRROR_ROOT}/kernel/caf
# TODO: fix this once repo supports refs removal in git config
#cd .repo/repo
#git pull origin stable
#cd ../../

#repo sync -j64 -vv --fail-fast
ls -d kernel/*.git | parallel -j64 git -C {} fetch clo
popd

# Sync AOSP mirror
pushd ${MIRROR_ROOT}/aosp
cd .repo/repo
git pull origin stable
cd ../../

repo sync -j64 -vv --fail-fast
popd

# Sync LineageOS mirror and set up alternates to AOSP and kernel mirrors
pushd ${MIRROR_ROOT}/scripts
scripts/aosp-mirror-to-lineage.sh
scripts/kernel-mirror-to-lineage.sh
popd

pushd ${MIRROR_ROOT}/lineage
cd .repo/repo
git pull origin stable
cd ../../

repo sync -j64 -vv --fail-fast --no-clone-bundle
popd

# Sync CalyxOS mirror and set up alternates to AOSP and kernel mirrors
pushd ${MIRROR_ROOT}/scripts
scripts/aosp-mirror-to-calyx.sh
scripts/kernel-mirror-to-calyx.sh
popd

pushd ${MIRROR_ROOT}/calyx
cd .repo/repo
git pull origin stable
cd ../../

repo sync -j64 -vv --fail-fast --no-clone-bundle
popd

# Sync proprietary files mirrors
pushd ${MIRROR_ROOT}/muppets
cd .repo/repo
git pull origin stable
cd ../../

repo sync -j64 -vv --fail-fast --no-clone-bundle
popd

pushd ${MIRROR_ROOT}/the-muppets
cd .repo/repo
git pull origin stable
cd ../../

repo sync -j64 -vv --fail-fast --no-clone-bundle
popd
