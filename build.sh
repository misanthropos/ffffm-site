#!/bin/bash

# Based on https://gitlab.karlsruhe.freifunk.net/firmware/site/-/blob/gluon-v2020.1.x/ci.sh by Julian Schuh and Simon Terzenbach

set -ex

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
	echo "Preparing build..."

	export FORCE_UNSAFE_CONFIGURE=1
	if [ ! -z ${GLUON_VERBOSE} ]; then
		export VERBOSE=V=1
	else
		export VERBOSE=
	fi

	make show-release $VERBOSE

	echo "building for targets '${SELECTED_TARGETS}'"
	for target in ${SELECTED_TARGETS}; do
		echo -e "Starting to build target \033[32m${target}\033[0m ..."
		make GLUON_TARGET=${target} -j"$(nproc)" $VERBOSE
	done
}

build_all() {
	update
	SELECTED_TARGETS=$(make list-targets)
	build
	manifest
}

manifest() {
	echo "Preparing build..."

	export FORCE_UNSAFE_CONFIGURE=1
	export VERBOSE=V=1

	make show-release $VERBOSE

	echo "Building Manifest"
	make manifest $VERBOSE
}

commands="build|manifest|build_all|update"
if [[ $1 =~ ^($commands)$ ]]; then
	"$@"
else
	echo >&2 ''
	echo >&2 "Invalid subcommand $1"
	echo >&2 "Usage: $0 [${commands}]"
	exit 1
fi
