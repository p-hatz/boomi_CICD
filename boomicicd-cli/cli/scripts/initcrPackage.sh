#!/bin/bash

set -a

source $WD/bin/common.sh
source $WD/bin/propertiesCICD.sh

ARGUMENTS=(authToken componentId packageVersion notes componentType extractComponentXmlFolder)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

$WD/bin/createPackage.sh componentId=$componentId packageVersion=$packageVersion componentType=$componentType notes="$notes" extractComponentXmlFolder="$extractComponentXmlFolder="
