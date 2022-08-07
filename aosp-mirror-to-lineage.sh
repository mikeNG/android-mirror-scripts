#!/bin/bash

MIRROR_ROOT=${MIRROR_ROOT:=/mnt/mirrors}

AOSP_MIRROR=${MIRROR_ROOT}/aosp
LINEAGE_MIRROR=${MIRROR_ROOT}/lineage

projects=`find ${AOSP_MIRROR}/platform/ -type d -name "*.git" | sed s#${AOSP_MIRROR}/##g | sed s#.git##g | sed s#platform/#android/#g | sed s#/#_#g`

aosp_project() {
	aosp_project_name=`echo $1 | sed s#android_##g | sed s#_#/#g | sed s#libhardware/legacy#libhardware_legacy#g | sed s#external/chromium/org#external/chromium_org#g | sed s#third/party#third_party#g | sed s#openmax/dl#openmax_dl#g | sed s#libjpeg/turbo#libjpeg_turbo#g | sed s#x86/64#x86_64#g | sed s#wpa/supplicant/#wpa_supplicant_#g | sed s#wpa/supplicant#wpa_supplicant#g | sed s#intel/audio/media#intel/audio_media#g | sed s#wrs/omxil/core#wrs_omxil_core#g | sed s#bd/prov#bd_prov#g | sed s#psb/video#psb_video#g | sed s#psb/headers#psb_headers#g | sed s#update/engine#update_engine#g | sed s#incremental/delivery#incremental_delivery#g | sed s#sound/trigger/hal#sound_trigger_hal#g | sed s#samsung/slsi#samsung_slsi#g | sed s#platform/testing#platform_testing#g | sed s#xmp/toolkit#xmp_toolkit#g | sed s#libnetfilter/conntrack#libnetfilter_conntrack#g | sed s#fsck/msdos#fsck_msdos#g | sed s#dng/sdk#dng_sdk#g`
	echo ${AOSP_MIRROR}/platform/${aosp_project_name}.git
}

pushd ${LINEAGE_MIRROR}
for i in $projects; do
	#echo $i
	grep -q $i .repo/manifests/default.xml
	if [ $? -eq 0 ]; then
		if [ ! -d LineageOS/$i.git ] ; then
			echo $i
			if [ ! -d "`aosp_project $i`/objects" ] ; then
				echo "`aosp_project $i`/objects" does not exist
				continue;
			fi
			mkdir -p LineageOS/$i.git
			GIT_DIR="LineageOS/$i.git" git init --bare
			echo "`aosp_project $i`/objects" > LineageOS/$i.git/objects/info/alternates
		fi
	fi
done
popd
