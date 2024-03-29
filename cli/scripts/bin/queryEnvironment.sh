#!/bin/bash

#source $WD/bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env classification)
URL=$baseURL/Environment/query
id=result[0].id
exportVariable=envId

inputs "$@" 
if [ "$?" -gt "0" ]
then
   return 255;
fi

if [ "${classification}" = "*" ]
then
 JSON_FILE=$WD/json/queryEnvironmentAnyClassification.json
else
 JSON_FILE=$WD/json/queryEnvironment.json
fi

createJSON

callAPI
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
