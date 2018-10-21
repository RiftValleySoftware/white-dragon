#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"
jazzy --github_url https://github.com/LittleGreenViper/white-dragon --readme ./README.md --module WhiteDragon
cp -R doc-images/ docs/doc-images/
cd "${CWD}"
