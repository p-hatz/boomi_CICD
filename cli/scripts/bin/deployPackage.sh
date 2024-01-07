#!/bin/bash
source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env packageVersion notes listenerStatus)
OPT_ARGUMENTS=(componentId processName componentVersion extractComponentXmlFolder tag componentType)

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

saveNotes="${notes}";
saveTag="${tag}"


source ${GITHUB_WORKSPACE}/cli/scripts/bin/createSinglePackage.sh componentId=${componentId} processName="${processName}" componentType="${componentType}" componentVersion="${componentVersion}" packageVersion="$packageVersion" notes="$notes" extractComponentXmlFolder="${extractComponentXmlFolder}" 
notes="${saveNotes}";

source ${GITHUB_WORKSPACE}/cli/scripts/bin/queryEnvironment.sh env="$env" classification="*"
saveEnvId=${envId}

source ${GITHUB_WORKSPACE}/cli/scripts/bin/createDeployedPackage.sh envId=${envId} listenerStatus="${listenerStatus}" packageId=$packageId notes="$notes"

handleXmlComponents "${saveExtractComponentXmlFolder}" "${saveTag}" "${saveNotes}"

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

export envId=${saveEnvId}

clean
