#!/usr/bin/env bash

MIRROR_ROOT=${MIRROR_ROOT:=/mnt/mirrors}

LINEAGE_MIRROR=${MIRROR_ROOT}/lineage
MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/lineage-mirror-manifest
KERNEL_MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/kernel-mirror-manifest

source ${KERNEL_MIRROR_MANIFEST}/lineage-metadata

pushd ${LINEAGE_MIRROR}
for repo in "${!kernel_map[@]}"; do
	grep -q $repo ${MIRROR_MANIFEST}/default.xml
	if [ $? -eq 0 ] ; then
		if [ ! -d LineageOS/$repo.git ] ; then
			echo "Creating empty repository:" LineageOS/$repo.git
			mkdir -p LineageOS/$repo.git
			GIT_DIR="LineageOS/$repo.git" git init --bare

			case ${kernel_map[$repo]} in
				2.6|3.0|3.1|3.4)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				3.10)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-3.10.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				3.18)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-3.18.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				4.4)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.4.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				4.9)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.9.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				4.14)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.14.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				4.19)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-4.19.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				5.4)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-5.4.git/objects > LineageOS/$repo.git/objects/info/alternates
					;;
				5.10)
					echo ${MIRROR_ROOT}/kernel/caf/kernel/msm-5.10.git/objects > LineageOS/$repo.git/objects/info/alternates
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
