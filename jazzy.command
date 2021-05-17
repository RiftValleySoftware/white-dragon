#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"
jazzy   --github_url https://github.com/LittleGreenViper/white-dragon\
        --theme fullwidth\
        --readme ./README.md\
        --module WhiteDragon\
        --config jazzy.yaml
cp -R doc-images/ docs/doc-images/
cd "${CWD}"
