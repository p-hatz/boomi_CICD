#!/bin/bash

set -a

source bin/common.sh

echo in script $authToken

ARGUMENTS=(env componentId componentType fieldVal)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

source bin/queryEnvironment.sh "env=$env" classification="*"

bin/updateExtensions.sh environmentId=$envId componentId=$componentId componentType=$componentType fieldVal="$fieldVal"
