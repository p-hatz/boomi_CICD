#!/bin/bash

ARGUMENTS=(authToken runtimeType duration)
inputs "$@"

if [ "$?" -gt "0" ]
then
   return 255;
fi

ARGUMENTS=(runtimeType duration)
JSON_FILE=$WD/json/createInstallerToken.json
URL=$baseURL/InstallerToken
createJSON
callAPI

extract token token
