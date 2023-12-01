#!/usr/bin/env bash

SCRIPT_PATH="$(cd "$(dirname "$0")";pwd -P)"
MIRROR_ROOT="${SCRIPT_PATH}/../.."

CALYX_MIRROR=${MIRROR_ROOT}/calyx
MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/calyx-mirror-manifest
KERNEL_MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/kernel-mirror-manifest

source ${KERNEL_MIRROR_MANIFEST}/calyx-metadata

pushd ${CALYX_MIRROR}
for repo in "${!kernel_map[@]}"; do
	grep -q $repo ${MIRROR_MANIFEST}/default.xml
	if [ $? -eq 0 ] ; then
		if [ ! -d CalyxOS/$repo.git ] ; then
			echo "Creating empty repository:" CalyxOS/$repo.git
			mkdir -p CalyxOS/$repo.git
			GIT_DIR="CalyxOS/$repo.git" git init --bare

			case ${kernel_map[$repo]} in
				2.6|3.0|3.1|3.4)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				3.10)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-3.10.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				3.18)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-3.18.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				4.4)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.4.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				4.9)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.9.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				4.14)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.14.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				4.19)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.19.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				5.4)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-5.4.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				5.10)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-5.10.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
				*)
					echo ${kernel_map[$repo]} "is not a valid CAF kernel version, falling back to AOSP"
					echo ${MIRROR_ROOT}/kernel/aosp/kernel/common.git/objects > CalyxOS/$repo.git/objects/info/alternates
					;;
			esac
		fi
	else
		echo $repo.git "not found in mirror manifest!"
	fi
done
popd
