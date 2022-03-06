#!/bin/bash

rebuild="false"
flash="false"
skip_build="false"

help()
{
    echo "Build helper script. Syntax: ./build.sh [-h|-r|-f|-s]"
    echo "  -h      Print help"
    echo "  -r      Rebuild"
    echo "  -f      Flash target"
    echo "  -s      Skip build"
}

while getopts ":hrfs" option; do
    case $option in
        h)  help
            exit;;
        r)  rebuild="true";;
        f)  flash="true";;
        s) skip_build="true";;
        \?) # Invalid option
            echo "Error: Invalid option"
            exit;;
    esac
done

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR=${SCRIPT_DIR}/build/

if [ $skip_build == "false" ]; then
    if [ $rebuild == "true" ]; then
        rm -rf ${BUILD_DIR}/*
    fi

    mkdir -p ${BUILD_DIR}

    cd ${BUILD_DIR} && cmake ..
    make -j${nproc}

    if [ $? -eq 0 ]; then
        echo "Build succesful"
    else
        echo "Build failed. Could not flash target"
    fi
fi

if [ $flash == "true" ]; then
    cd ${SCRIPT_DIR}
	ST-LINK_CLI.exe -c SWD FREQ=4000 -P ./build/guitar-signal-processor.bin 0x08000000 -HardRst
fi

