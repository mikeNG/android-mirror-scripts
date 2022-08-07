#!/usr/bin/env bash

MIRROR_ROOT=${MIRROR_ROOT:=/mnt/mirrors}

CALYX_MIRROR=${MIRROR_ROOT}/calyx

WEBLATE_PROJECTS="platform_frameworks_base.git platform_packages_apps_CellBroadcastReceiver.git platform_packages_apps_Launcher3.git platform_packages_apps_contacts.git platform_packages_apps_dialer.git platform_packages_apps_settings.git"

if [ ! -d "${CALYX_MIRROR}/CalyxOS/weblate" ] ; then
	mkdir -p "${CALYX_MIRROR}/CalyxOS/weblate"
fi

pushd ${CALYX_MIRROR}/CalyxOS/weblate
for weblate_project in ${WEBLATE_PROJECTS}; do
	if [ ! -d weblate_project.git ] ; then
		mkdir -p $weblate_project
		GIT_DIR="$weblate_project" git init --bare
	fi
done

echo ${MIRROR_ROOT}/aosp/platform/frameworks/base.git/objects > platform_frameworks_base.git/objects/info/alternates
echo ${MIRROR_ROOT}/aosp/platform/packages/apps/CellBroadcastReceiver.git/objects > platform_packages_apps_CellBroadcastReceiver.git/objects/info/alternates
echo ${MIRROR_ROOT}/aosp/platform/packages/apps/Launcher3.git/objects > platform_packages_apps_Launcher3.git/objects/info/alternates
echo ${MIRROR_ROOT}/aosp/platform/packages/apps/Contacts.git/objects > platform_packages_apps_contacts.git/objects/info/alternates
echo ${MIRROR_ROOT}/aosp/platform/packages/apps/Dialer.git/objects > platform_packages_apps_dialer.git/objects/info/alternates
echo ${MIRROR_ROOT}/aosp/platform/packages/apps/Settings.git/objects > platform_packages_apps_settings.git/objects/info/alternates
popd
