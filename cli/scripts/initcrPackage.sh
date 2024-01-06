#!/bin/bash

set -a

#source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh
#source $WD/bin/propertiesCICD.sh

ARGUMENTS=(authToken componentId packageVersion notes componentType extractComponentXmlFolder)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

echo pre $authToken > /tmp/pre.out
${GITHUB_WORKSPACE}/cli/scripts/bin/createPackage.sh authToken=$authToken componentId=$componentId packageVersion=$packageVersion componentType=$componentType notes="$notes" extractComponentXmlFolder="$extractComponentXmlFolder="
