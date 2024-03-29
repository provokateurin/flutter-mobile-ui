#!/bin/bash
set -euxo pipefail
# shellcheck disable=SC2155
export PATH=$(pwd)/flutter-elinux/bin:$PATH
# shellcheck disable=SC2155
export GSETTINGS_SCHEMA_DIR=$(pwd)/phoc/_build/data

function build_phoc() {
    (
        cd phoc
        reconfigure=""
        if [ -d _build ]; then
            reconfigure="--reconfigure"
        fi
        meson $reconfigure -Dbuildtype=release -Dembed_wlroots=true -Ddefault_library=static -Doptimization=3 -Dstrip=true -Db_lto=true . _build
        ninja -C _build
    )
}

function kill_phoc() {
    killall phoc
}

function run_phoc() {
    build_phoc
    trap kill_phoc EXIT
    ./phoc/_build/run -C ./phoc.ini "$@" &
}
