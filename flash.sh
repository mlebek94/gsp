#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR=${SCRIPT_DIR}/build
TARGET_NAME=$1

cd ${SCRIPT_DIR}
ST-LINK_CLI.exe -c SWD FREQ=4000 -P ./build/app/${TARGET_NAME}/${TARGET_NAME}.bin 0x08000000 -HardRst
