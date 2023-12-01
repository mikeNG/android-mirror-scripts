#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "$0")";pwd -P)"
MIRROR_ROOT="${SCRIPT_PATH}/../.."

AOSP_MIRROR=${MIRROR_ROOT}/aosp
CALYX_MIRROR=${MIRROR_ROOT}/calyx

projects=`find ${AOSP_MIRROR}/platform/ -type d -name "*.git" | sed s#${AOSP_MIRROR}/##g | sed s#.git##g | sed s#/#_#g`

aosp_project() {
	aosp_project_name=`echo $1 | sed s#_#/#g | sed s#libhardware/legacy#libhardware_legacy#g | sed s#update/engine#update_engine#g | sed s#sound/trigger/hal#sound_trigger_hal#g`
	echo ${AOSP_MIRROR}/${aosp_project_name}.git
}

pushd ${CALYX_MIRROR}
for i in $projects; do
	#echo $i
	grep -q $i .repo/manifests/default.xml
	if [ $? -eq 0 ]; then
		if [ ! -d CalyxOS/$i.git ] ; then
			echo $i
			if [ ! -d "`aosp_project $i`/objects" ] ; then
				echo "`aosp_project $i`/objects" does not exist
				continue;
			fi
			mkdir -p CalyxOS/$i.git
			GIT_DIR="CalyxOS/$i.git" git init --bare
			echo "`aosp_project $i`/objects" > CalyxOS/$i.git/objects/info/alternates
		fi
	fi
done
popd
