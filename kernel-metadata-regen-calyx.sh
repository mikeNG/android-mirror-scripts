#!/usr/bin/env bash

MIRROR_ROOT=${MIRROR_ROOT:=../../}

CALYX_MIRROR=${MIRROR_ROOT}/calyx
MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/calyx-mirror-manifest
KERNEL_MIRROR_MANIFEST=${MIRROR_ROOT}/scripts/kernel-mirror-manifest

kernels=`grep 'CalyxOS/kernel' ${MIRROR_MANIFEST}/default.xml | grep -v -e 'kernel_build' -e 'kernel_manifest' -e 'drivers_staging' -e 'techpack_audio' -e 'kernel_devices' -e 'kernel_configs' | sed -e 's#  <project name="CalyxOS/##g' -e 's#" />##g'`

echo -e "declare -A kernel_map\n" > ${KERNEL_MIRROR_MANIFEST}/calyx-metadata

for kernel in $kernels; do
    (
	# set current VERSION, PATCHLEVEL
	# force $TMPFILEs below to be in local directory: a slash character prevents
	# the dot command from using the search path.
	TMPFILE=`mktemp ./.tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
	curl -s https://gitlab.com/CalyxOS/$kernel/-/raw/HEAD/Makefile | grep -E "^(VERSION|PATCHLEVEL)" > $TMPFILE
	tr -d [:blank:] < $TMPFILE > $TMPFILE.1
	. $TMPFILE.1
	rm -f $TMPFILE*
	if [ -z "$VERSION" -o -z "$PATCHLEVEL" ] ; then
		echo "unable to determine current kernel version for" $kernel >&2
        exit;
	fi

	KERNEL_VERSION="$VERSION.$PATCHLEVEL"

	echo "kernel_map["$kernel"]="$KERNEL_VERSION >> ${KERNEL_MIRROR_MANIFEST}/calyx-metadata

	unset VERSION
	unset PATCHLEVEL
    ) &
done
