# Process Schedule Status Query by passing the processId and atomId
# Usage : queryProcessSchedules.sh <atomName> <atomType> <processName>
#!/bin/bash

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

#Query Process Schedule Status  by atomId and processId
ARGUMENTS=(atomName atomType processName)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

source $WD/bin/queryAtom.sh atomName="$atomName" atomStatus=online atomType=$atomType

source $WD/bin/queryProcess.sh processName="$processName"

ARGUMENTS=(atomId processId)
JSON_FILE=$WD/json/queryProcessSchedules.json
URL=$baseURL/ProcessSchedules/query
id=result[0].id
exportVariable=scheduleId

createJSON

callAPI
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
