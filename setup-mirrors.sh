#!/usr/bin/env bash

SCRIPT_PATH="$(cd "$(dirname "$0")";pwd -P)"
MIRROR_ROOT="${SCRIPT_PATH}/../.."

MIRRORS="aosp lineage calyx muppets the-muppets"

AOSP_FOLDERS="device kernel platform toolchain tools"

for mirror in ${MIRRORS}; do
	if [ ! -d ${MIRROR_ROOT}/${mirror} ] ; then
		mkdir -p ${MIRROR_ROOT}/${mirror}
	fi
done

pushd ${MIRROR_ROOT}/aosp
if [ ! -d .repo ] ; then
	repo init -u https://android.googlesource.com/mirror/manifest --mirror
fi

if [ ! -d .repo/local_manifests ] ; then
	mkdir -p .repo/local_manifests

	ln -s ../../../scripts/scripts/remove-projects-aosp.xml .repo/local_manifests/remove-projects.xml
fi

if [ ! -L The-Muppets ] ; then
	ln -s ../the-muppets/The-Muppets The-Muppets
fi
if [ ! -L TheMuppets ] ; then
	ln -s ../muppets/TheMuppets TheMuppets
fi
if [ ! -L LineageOS ] ; then
	ln -s ../lineage/LineageOS LineageOS
fi
if [ ! -L CalyxOS ] ; then
	ln -s ../calyx/CalyxOS CalyxOS
fi
popd

pushd ${MIRROR_ROOT}/lineage
if [ ! -d .repo ] ; then
	repo init -u https://github.com/LineageOS/mirror --mirror
fi

for aosp_folder in ${AOSP_FOLDERS}; do
	if [ ! -L "${aosp_folder}" ] ; then
		ln -s "../aosp/${aosp_folder}" "${aosp_folder}"
	fi
done

if [ ! -L The-Muppets ] ; then
	ln -s ../the-muppets/The-Muppets The-Muppets
fi
if [ ! -L TheMuppets ] ; then
	ln -s ../muppets/TheMuppets TheMuppets
fi
if [ ! -L CalyxOS ] ; then
	ln -s ../calyx/CalyxOS CalyxOS
fi
popd

pushd ${MIRROR_ROOT}/calyx
if [ ! -d .repo ] ; then
	repo init -u https://gitlab.com/CalyxOS/mirror_manifest --mirror
fi

if [ ! -d .repo/local_manifests ] ; then
	mkdir -p .repo/local_manifests

	ln -s ../manifests/proprietary.xml .repo/local_manifests/proprietary.xml
fi

for aosp_folder in ${AOSP_FOLDERS}; do
	if [ ! -L "${aosp_folder}" ] ; then
		ln -s "../aosp/${aosp_folder}" "${aosp_folder}"
	fi
done

if [ ! -L The-Muppets ] ; then
	ln -s ../the-muppets/The-Muppets The-Muppets
fi
if [ ! -L TheMuppets ] ; then
	ln -s ../muppets/TheMuppets TheMuppets
fi
if [ ! -L LineageOS ] ; then
	ln -s ../lineage/LineageOS LineageOS
fi
popd

pushd ${MIRROR_ROOT}/muppets
if [ ! -d .repo ] ; then
	repo init -u https://github.com/TheMuppets/manifests -b mirror --mirror
fi
popd

pushd ${MIRROR_ROOT}/the-muppets
if [ ! -d .repo ] ; then
	repo init -u https://gitlab.com/The-Muppets/manifest -b mirror --mirror
fi
popd
