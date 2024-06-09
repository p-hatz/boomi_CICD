#!/bin/bash

set -a

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

ARGUMENTS=(authToken componentId componentType packageVersion envId codeCheck)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

source ${GITHUB_WORKSPACE}/cli/scripts/bin/queryPackagedComponent.sh authToken=$authToken componentId=$componentId packageVersion=$packageVersion componentType=$componentType
if [ -z "$packageId" ]
then
	echo "No package has been created for Component Id $componentId!"
	exit 1
fi

echo packageid: $packageId
source ${GITHUB_WORKSPACE}/cli/scripts/bin/queryDeployedPackage.sh envId=$envId packageId=$packageId
if [ -z "$deploymentId" ]
then
	echo "Package has been not been deployed to Dev"
	exit 1
fi

echo packageid: $packageId
if [ $codeCheck -eq 1 ]
then
	echo Checking code!...
        source "${GITHUB_WORKSPACE}/cli/scripts/initCheckRules.sh" packageId=$packageId extractComponentXmlFolder=CodeReview
fi              
