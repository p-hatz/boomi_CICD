#!/bin/bash

# Process Schedule Status Query by passing the processId and atomId
# Usage : queryProcessScheduleStatus.sh <atomId> <atomType> <processId>

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

#Query Process Schedule Status  by atomId and processId
ARGUMENTS=(atomName atomType)
OPT_ARGUMENTS=(processName componentId)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

source $WD/bin/queryAtom.sh atomName="$atomName" atomStatus=online atomType=$atomType

if [ -z "${componentId}" ] || [ null == "${componentId}" ]
then
 source $WD/bin/queryProcess.sh processName="$processName"
fi
processId="${componentId}"

ARGUMENTS=(atomId processId)
JSON_FILE=$WD/json/queryProcessScheduleStatus.json
URL=$baseURL/ProcessScheduleStatus/query
id=result[0].id
exportVariable=scheduleId

createJSON

callAPI
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
