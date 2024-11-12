#!/usr/bin/env bash

SCRIPT_PATH="$(cd "$(dirname "$(readlink -f "$0")")";pwd -P)"
MIRROR_ROOT="${SCRIPT_PATH}/../.."

export REPO_TRACE=0

# Default to repo sync -j64
SYNC_JOBS=64

SYNC_GITLAB_MUPPETS=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -j | --jobs )
                SYNC_JOBS="${2}";
                ;;
        -g | --sync-gitlab-muppets )
                SYNC_GITLAB_MUPPETS=true
                ;;
    esac
    shift
done

# Sync the scripts and required manifests
pushd ${MIRROR_ROOT}/scripts
repo sync -j"${SYNC_JOBS}" -vv --fail-fast

scripts/kernel-metadata-regen-lineage.sh
scripts/kernel-metadata-regen-calyx.sh
popd

# Sync linux and linux-stable kernels
pushd ${MIRROR_ROOT}/kernel/linux
repo sync -vv --fail-fast torvalds/linux
repo sync -vv --fail-fast stable/linux
popd

# Sync google kernels
pushd ${MIRROR_ROOT}/kernel/aosp
repo sync -vv --fail-fast kernel/common

repo sync -j"${SYNC_JOBS}" -vv --fail-fast
popd

# Sync qcom kernels
pushd ${MIRROR_ROOT}/kernel/caf
# TODO: fix this once repo supports refs removal in git config
#repo sync -j"${SYNC_JOBS}" -vv --fail-fast
ls -d kernel/*.git | parallel -j"${SYNC_JOBS}" git -C {} fetch clo
popd

# Sync AOSP mirror
pushd ${MIRROR_ROOT}/aosp
repo sync -j"${SYNC_JOBS}" -vv --fail-fast
popd

# Sync LineageOS mirror and set up alternates to AOSP and kernel mirrors
pushd ${MIRROR_ROOT}/scripts
scripts/aosp-mirror-to-lineage.sh
scripts/kernel-mirror-to-lineage.sh
popd

pushd ${MIRROR_ROOT}/lineage
repo sync -j"${SYNC_JOBS}" -vv --fail-fast --no-clone-bundle
popd

# Sync CalyxOS mirror and set up alternates to AOSP and kernel mirrors
pushd ${MIRROR_ROOT}/scripts
scripts/aosp-mirror-to-calyx.sh
scripts/kernel-mirror-to-calyx.sh
popd

pushd ${MIRROR_ROOT}/calyx
repo sync -j"${SYNC_JOBS}" -vv --fail-fast --no-clone-bundle
popd

# Sync proprietary files mirrors
pushd ${MIRROR_ROOT}/muppets
repo sync -j"${SYNC_JOBS}" -vv --fail-fast --no-clone-bundle
popd

if [[ "${SYNC_GITLAB_MUPPETS}" == "true" ]]; then
	pushd ${MIRROR_ROOT}/the-muppets
	repo sync -j"${SYNC_JOBS}" -vv --fail-fast --no-clone-bundle
	popd
fi
