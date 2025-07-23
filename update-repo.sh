#!/usr/bin/env bash

SCRIPT_PATH="$(cd "$(dirname "$(readlink -f "$0")")";pwd -P)"
MIRROR_ROOT="${SCRIPT_PATH}/../.."

MIRRORS="scripts kernel/linux kernel/aosp kernel/caf aosp lineage calyx muppets the-muppets"

for mirror in ${MIRRORS}; do
	pushd "${MIRROR_ROOT}/${mirror}/.repo/repo"
	git pull origin stable
	popd
done
