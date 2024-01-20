#!/bin/bash

source $WD/bin/common.sh 

# mandatory arguments
ARGUMENTS=(envId connectionId passVal)
JSON_FILE=$WD/json/updateEnvironmentExtension.json
inputs "$@"

URL=$baseURL/EnvironmentExtensions/$envId/update
createJSON

exit
 
if [ "$deploymentId" == "null" ] || [ -z "$deploymentId" ]
then 
	callAPI
exit
fi

if [ "$deploymentId" != "null" ] || [ ! -z "$deploymentId" ]
then 
	echoi "Deployed package ${packageId} in env ${envId} with deploymentId ${deploymentId}."	
fi

echo here
clean
if [ "$ERROR" -gt "0" ]
then
   return 255;
fi