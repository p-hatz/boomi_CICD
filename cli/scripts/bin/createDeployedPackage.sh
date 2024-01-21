#!/bin/bash

source $WD/bin/common.sh 
# Query processattachment id before creating it
echov "$@"
source $WD/bin/queryDeployedPackage.sh "$@"

# mandatory arguments
ARGUMENTS=(envId packageId notes listenerStatus)
JSON_FILE=$WD/json/createDeployedPackage.json
URL=$baseURL/DeployedPackage/
id=deploymentId
exportVariable=deploymentId
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
createJSON
 
if [ "$deploymentId" == "null" ] || [ -z "$deploymentId" ]
then 
	callAPI
exit
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
