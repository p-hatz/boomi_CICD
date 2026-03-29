#!/bin/bash

set -a

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

ARGUMENTS=(authToken componentId packageVersion notes componentType env listenerStatus)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

source ${GITHUB_WORKSPACE}/cli/scripts/bin/deployPackage.sh componentId=$componentId packageVersion=$packageVersion componentType=$componentType notes="$notes" env=$env listenerStatus=$listenerStatus
