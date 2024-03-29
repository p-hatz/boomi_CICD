#!/bin/bash

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomName atomType atomStatus)
JSON_FILE=$WD/json/queryAtom.json
URL=$baseURL/Atom/query
id=result[0].id
exportVariable=atomId

inputs "$@"

if [ "$?" -gt "0" ]
then
        return 255;
fi

if [ "$atomType" = "*" ] || [ "$atomStatus" = "*" ]
then
        JSON_FILE=$WD/json/queryAtomAny.json
fi
createJSON
 
callAPI
 
clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
