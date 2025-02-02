#!/bin/bash

set -a

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

ARGUMENTS=(authToken componentId packageVersion notes componentType extractComponentXmlFolder codeCheck)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

${GITHUB_WORKSPACE}/cli/scripts/bin/createPackage.sh authToken=$authToken componentId=$componentId packageVersion=$packageVersion componentType=$componentType notes="$notes" extractComponentXmlFolder="$extractComponentXmlFolder=" codeCheck="$codeCheck"
