#!/bin/bash

set -a

source bin/common.sh

ARGUMENTS=(authToken componentId packageVersion notes componentType env listenerStatus updExt)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

bin/deployPackage.sh componentId=$componentId packageVersion=$packageVersion componentType=$componentType notes="$notes" env=$env listenerStatus=$listenerStatus updExt=$updExt
