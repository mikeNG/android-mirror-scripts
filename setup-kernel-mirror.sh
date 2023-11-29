#!/usr/bin/env bash

MIRROR_ROOT=${MIRROR_ROOT:=../../}

KERNEL_MIRROR=${MIRROR_ROOT}/kernel
TORVALDS_LINUX=linux/torvalds/linux.git
STABLE_LINUX=linux/stable/linux.git
GOOGLE_COMMON=aosp/kernel/common.git

MIRRORS="linux aosp caf"

AOSP_PROJECTS="kernel/arm64 kernel/exynos kernel/goldfish kernel/gs kernel/hikey-linaro kernel/mediatek kernel/msm kernel/omap kernel/samsung kernel/tegra kernel/x86_64 kernel/x86"
CAF_PROJECTS="kernel/msm kernel/msm-3.10 kernel/msm-3.18 kernel/msm-4.4 kernel/msm-4.9 kernel/msm-4.14 kernel/msm-4.19 kernel/msm-5.4 kernel/msm-5.10"

for mirror in ${MIRRORS}; do
	if [ ! -d ${KERNEL_MIRROR}/${mirror} ] ; then
		mkdir -p ${KERNEL_MIRROR}/${mirror}
	fi
done

pushd ${KERNEL_MIRROR}/linux
if [ ! -d .repo ] ; then
	repo init -u https://github.com/mikeNG/kernel-mirror --mirror
fi

if [ ! -d stable/linux.git ] ; then
	mkdir -p stable/linux.git
	GIT_DIR="stable/linux.git" git init --bare
	echo ${KERNEL_MIRROR}/linux/torvalds/linux.git/objects > stable/linux.git/objects/info/alternates
fi
popd

pushd ${KERNEL_MIRROR}/aosp
if [ ! -d .repo ] ; then
	repo init -u https://github.com/mikeNG/kernel-mirror --mirror --manifest-name aosp.xml
fi

if [ ! -d kernel/common.git ] ; then
	mkdir -p kernel/common.git
	GIT_DIR="kernel/common.git" git init --bare
	echo ${KERNEL_MIRROR}/${TORVALDS_LINUX}/objects > kernel/common.git/objects/info/alternates
	echo ${KERNEL_MIRROR}/${STABLE_LINUX}/objects >> kernel/common.git/objects/info/alternates
fi

for aosp_project in ${AOSP_PROJECTS}; do
	if [ ! -d "${aosp_project}.git" ] ; then
		mkdir -p "${aosp_project}.git"
		GIT_DIR="${aosp_project}.git" git init --bare
		echo ${KERNEL_MIRROR}/${TORVALDS_LINUX}/objects > "${aosp_project}.git/objects/info/alternates"
		echo ${KERNEL_MIRROR}/${STABLE_LINUX}/objects >> "${aosp_project}.git/objects/info/alternates"
		echo ${KERNEL_MIRROR}/${GOOGLE_COMMON}/objects >> "${aosp_project}.git/objects/info/alternates"
	fi

	if [ ! -L "${MIRROR_ROOT}/aosp/${aosp_project}.git" ] ; then
		ln -s "../../kernel/aosp/${aosp_project}.git" "${MIRROR_ROOT}/aosp/${aosp_project}.git"
	fi
done
popd

pushd ${KERNEL_MIRROR}/caf
if [ ! -d .repo ] ; then
	repo init -u https://github.com/mikeNG/kernel-mirror --mirror --manifest-name caf.xml
fi

for caf_project in ${CAF_PROJECTS}; do
	if [ ! -d "${caf_project}.git" ] ; then
		mkdir -p "${caf_project}.git"
		GIT_DIR="${caf_project}.git" git init --bare
		echo ${KERNEL_MIRROR}/${TORVALDS_LINUX}/objects > "${caf_project}.git/objects/info/alternates"
		echo ${KERNEL_MIRROR}/${STABLE_LINUX}/objects >> "${caf_project}.git/objects/info/alternates"
		echo ${KERNEL_MIRROR}/${GOOGLE_COMMON}/objects >> "${caf_project}.git/objects/info/alternates"
	fi
done
popd
