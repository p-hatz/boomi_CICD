#!/bin/bash

source $WD/bin/common.sh

# mandatory arguments
ARGUMENTS=(environmentId componentId key fieldVal default)
JSON_FILE=$WD/json/updateEnvironmentExtension-PP.json
inputs "$@"

URL=$baseURL/EnvironmentExtensions/$environmentId/update
createJSON

if [ "$deploymentId" == "null" ] || [ -z "$deploymentId" ]
then 
	callAPI
fi

if [ "$deploymentId" != "null" ] || [ ! -z "$deploymentId" ]
then 
	echoi "Deployed package ${packageId} in env ${envId} with deploymentId ${deploymentId}."	
fi

clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi
