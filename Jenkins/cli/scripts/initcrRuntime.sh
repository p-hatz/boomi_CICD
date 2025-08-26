#!/bin/bash

set -a

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

ARGUMENTS=(authToken runtimeType tokenDuration atomName accountId installDir)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

source ${GITHUB_WORKSPACE}/cli/scripts/bin/getInstallerToken.sh authToken=$authToken runtimeType=$runtimeType duration=$tokenDuration
echo token: $token
if [ ! -z "$token" ]
then
	curl -so ${GITHUB_WORKSPACE}/cli/scripts/tmp/atom_install64.sh https://platform.boomi.com/atom/atom_install64.sh
	chmod 755 ${GITHUB_WORKSPACE}/cli/scripts/tmp/atom_install64.sh

	sudo -u peter ${GITHUB_WORKSPACE}/cli/scripts/tmp/atom_install64.sh -q -console -VinstallToken="$token" -VatomName=$atomName -VaccountId=$accountId -dir $installDir -VenvironmentId=$environmentId
	_ret="$?"
	if [ "$_ret" -eq 0 ]
	then
		echo Runtime installed successfully
	fi
fi
