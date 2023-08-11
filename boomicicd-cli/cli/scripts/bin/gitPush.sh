#!/bin/bash


if [ "${gitComponentOption}" == "CLONE" ]
then
   $WD/bin/gitClone.sh "$@"
else
  $WD/bin/gitRelease.sh "$@"
fi
