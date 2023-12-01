#!/usr/bin/env bash

MIRROR_ROOT=${MIRROR_ROOT:=/mnt/mirrors}

LINEAGE_MIRROR=${MIRROR_ROOT}/lineage
MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/lineage-mirror-manifest
KERNEL_MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/kernel-mirror-manifest

kernels=`grep kernel ${MIRROR_MANIFEST}/default.xml | grep -v \
-e 'android_device' \
-e 'android_external' \
-e 'android_hardware' \
-e 'hardware_nvidia' \
-e 'kernel_asus_tf700t' \
-e 'kernel_configs' \
-e 'kernel_letv_msm8994' \
-e 'kernel_nvidia_cypress-fmac' \
-e 'kernel_nvidia_display' \
-e 'kernel_nvidia_linux-4.9_kernel_nvgpu' \
-e 'kernel_nvidia_linux-4.9_kernel_nvidia' \
-e 'kernel_nvidia_mainline' \
-e 'kernel_nvidia_nvgpu' \
-e 'kernel_nvidia_nvidia' \
-e 'kernel_nvidia_wireguard' \
-e 'kernel_nvidia_nvethernetrm' \
-e 'kernel_oppo_msm8226' \
-e 'kernel_qcom_msm8974' \
-e 'kernel_samsung_kyleproxx' \
-e 'kernel_samsung_ms013g' \
-e 'kernel_samsung_smdk5260' \
-e 'kernel_samsung_v2wifixx' \
-e 'kernel_samsung_victory' \
-e 'kernel_samsung_zenltexx' \
-e 'vendor_qcom_opensource_kernel-tests_mm-audio' \
-e 'lge-kernel-msm7x27' \
-e 'htc-kernel-pyramid' \
-e 'htc-kernel-msm8660' \
-e 'geeksphone-kernel-zero' \
-e 'prebuilts_clang_kernel' \
-e 'sm8450-devicetrees' \
-e 'sm8550-devicetrees' \
-e 'sm8450-modules' \
-e 'sm8550-modules' \
| sed -e 's#  <project name="LineageOS/##g' -e 's#" />##g'`

echo -e "declare -A kernel_map\n" > ${KERNEL_MIRROR_MANIFEST}/lineage-metadata

for kernel in $kernels; do
	(
	# set current VERSION, PATCHLEVEL
	# force $TMPFILEs below to be in local directory: a slash character prevents
	# the dot command from using the search path.
	TMPFILE=`mktemp ./.tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
	curl -s https://raw.githubusercontent.com/LineageOS/$kernel/HEAD/Makefile | grep -E "^(VERSION|PATCHLEVEL)" > $TMPFILE
	tr -d [:blank:] < $TMPFILE > $TMPFILE.1
	. $TMPFILE.1
	rm -f $TMPFILE*
	if [ -z "$VERSION" -o -z "$PATCHLEVEL" ] ; then
		echo "unable to determine current kernel version for" $kernel >&2
		exit;
	fi

	KERNEL_VERSION="$VERSION.$PATCHLEVEL"

	echo "kernel_map["$kernel"]="$KERNEL_VERSION >> ${KERNEL_MIRROR_MANIFEST}/lineage-metadata

	unset VERSION
	unset PATCHLEVEL
	) &
done

wait
