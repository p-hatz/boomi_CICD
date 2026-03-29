#!/bin/bash
source "${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh"

WORKSPACE=/tmp

# mandatory arguments
ARGUMENTS=(packageVersion notes)
OPT_ARGUMENTS=(componentId processName extractComponentXmlFolder componentVersion tag componentType)

inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

if [ ! -z "${extractComponentXmlFolder}" ]
then
 folder="${WORKSPACE}/${extractComponentXmlFolder}"
 rm -rf ${folder}
 unset extensionJson
 saveExtractComponentXmlFolder="${extractComponentXmlFolder}"
fi

saveNotes="${notes}"
saveTag="${tag}"

source "${GITHUB_WORKSPACE}/cli/scripts/bin/createSinglePackage.sh "$@"
if [ "$?" -eq 255 ]
then
    echo "Issue found with packaging. Bailing!"
    return 255
elif [ "$?" -gt 0 ] && [ "$?" -le 255 ]
then
    return "$?"
fi

handleXmlComponents "${saveExtractComponentXmlFolder}" "${saveTag}" "${saveNotes}"

if [ "$ERROR" -gt 0 ]
 then
    return 255;
fi
