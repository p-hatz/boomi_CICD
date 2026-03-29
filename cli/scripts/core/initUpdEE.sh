#!/bin/bash

set -a

source "${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh"

ARGUMENTS=(env componentId componentType fieldVal)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

source "${GITHUB_WORKSPACE}/cli/scripts/bin/queryEnvironment.sh" "env=$env" classification="*"

"${GITHUB_WORKSPACE}/cli/scripts/bin/updateExtensions.sh" environmentId=$envId componentId=$componentId componentType=$componentType fieldVal="$fieldVal"
