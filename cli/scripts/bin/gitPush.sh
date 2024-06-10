#!/bin/bash

saveNotes="${saveNotes}: ${compId}:${compVer}"
echo savenotes: $saveNotes
if [ "${gitComponentOption}" == "CLONE" ]
then
   source $WD/bin/gitClone.sh notes="${saveNotes}"
   #source $WD/bin/gitClone.sh "$@"
else
  source $WD/bin/gitRelease.sh "$@"
fi
