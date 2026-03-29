#!/bin/bash

set -a

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

ARGUMENTS=(authToken componentId componentType packageVersion envId codeCheck checkDeployment)
inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

saveComponentId=${componentId}
echo save1: $saveComponentId

source ${GITHUB_WORKSPACE}/cli/scripts/bin/queryPackagedComponent.sh authToken=$authToken componentId=$componentId packageVersion=$packageVersion componentType=$componentType
if [ -z "$packageId" ]
then
	echo "No package has been created for Component Id $componentId!"
	exit 1
fi

echo save: $saveComponentId
savePackageId=$packageId

if [ $checkDeployment -eq 0 ]
then
	echo "Not checking for deployment"
else
	source ${GITHUB_WORKSPACE}/cli/scripts/bin/queryDeployedPackage.sh envId=$envId packageId=$packageId
	echo deploymentid: $deploymentId
	if [ -z "$deploymentId" ] || [ "$deploymentId" = "null" ]
	then
		echo "Package has been not been deployed to previous Environment!"
		exit 1
	fi
fi

echo save: $saveComponentId
if [ $codeCheck -eq 1 ]
then
	echo Checking code!...
        source "${GITHUB_WORKSPACE}/cli/scripts/initCheckRules.sh" packageId=$savePackageId componentId=$saveComponentId extractComponentXmlFolder=CodeReview
fi          
