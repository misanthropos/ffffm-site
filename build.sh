#!/bin/bash

# Based on https://gitlab.karlsruhe.freifunk.net/firmware/site/-/blob/gluon-v2020.1.x/ci.sh by Julian Schuh and Simon Terzenbach

set -ex

if [[ -n "$2" ]] && [[ -r "$2" ]]; then key_file="$(realpath "$2")"; fi
if [[ -n "$3" ]]; then manifest_file="$(realpath "$3")"; fi

cd "$(dirname "${BASH_SOURCE[0]}")"

make -f gluon.mk
eval "$(make -s -f helper.mk)"

echo -e "COMMIT_DESCRIPTION: ${COMMIT_DESCRIPTION}"
echo -e "GLUON_CHECKOUT: ${GLUON_CHECKOUT}"
echo -e "GLUON_BRANCH: ${GLUON_BRANCH}"
echo -e "GLUON_RELEASE: ${GLUON_RELEASE}"
echo -e "GLUON_PRIORITY: ${GLUON_PRIORITY}"

cd ..

update() {
	make update
}

build() {
	echo 'Preparing build...'

	export FORCE_UNSAFE_CONFIGURE=1
	if [ -n "${GLUON_VERBOSE}" ]; then
		export VERBOSE=V=1
	else
		export VERBOSE=
	fi

	make show-release $VERBOSE

	echo "building for targets '${SELECTED_TARGETS}'"
	for target in ${SELECTED_TARGETS}; do
		echo -e "Starting to build target \033[32m${target}\033[0m ..."
		make GLUON_TARGET="${target}" -j"$(nproc)" $VERBOSE
	done
}

build_all() {
	update
	SELECTED_TARGETS=$(make list-targets)
	build
	manifest
}

manifest() {
	echo 'Preparing build...'

	export FORCE_UNSAFE_CONFIGURE=1
	export VERBOSE=V=1

	make show-release $VERBOSE

	echo 'Building Manifest'
	make manifest $VERBOSE
}

sign() {
	if [[ $# != 2 ]]; then >&2 echo "$0 sign [key or key file] [manifest file]"; exit 1; fi

	key=$1
	manifest=$2

	if [[ -r "${key}" ]]; then key=$(cat "${key}"); fi # Read key fom file

	echo 'Signing Manifest'
	contrib/sign.sh <(echo "${key}") "${manifest}"
}


commands='build|build_all|manifest|sign|update'
if [[ "$1" =~ ^($commands)$ ]]; then
	if [[ "$1" == "sign" ]]; then sign "${key_file:-"$2"}" "$manifest_file"; exit; fi
	"$@"
else
	echo >&2 ''
	echo >&2 "Invalid subcommand $1"
	echo >&2 "Usage: $0 [${commands}]"
	echo >&2 ''
	echo >&2 '  build     Build in $SELECTED_TARGETS specified targets'
	echo >&2 '  build_all Build all gluon targets'
	echo >&2 '  manifest  Create a manifest for the last build'
	echo >&2 '  sign      Sign a manifest file'
	echo >&2 '  update    Update gluon, required on gluon version changes'
	exit 1
fi
