#!/bin/bash
source $WD/bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(deploymentId)

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

ERROR=0
_URL="DeployedPackage"
URL="$baseURL/$_URL/$deploymentId"
curl -s -X DELETE -u $authToken $baseURL/DeployedPackage/$deploymentId > "${WORKSPACE}"/tmp.json

_err=$(xmllint --xpath '//error[1]' "${WORKSPACE}"/tmp.json)
if echo $_err | grep "Unable to find a deployment with the specified deployment ID in the specified account" 2> /dev/null
then
	echo "Failed to undeploy '$deploymentId'!"
	ERROR=1
else
	echo "Undeployed '$deploymentId'"
fi

if [ "$ERROR" -gt "0" ]
then
   return 255;
fi

clean
