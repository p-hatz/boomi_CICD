#!/bin/bash

set -a

source ${GITHUB_WORKSPACE}/cli/scripts/bin/common.sh

ARGUMENTS=(packageId componentId extractComponentXmlFolder)

inputs "$@"
if [ "$?" -gt 0 ]
then
	exit $?
fi

savePackageId=${packageId}
saveComponentId=${componentId}

# Extract Boomi componentXMLs to a local disk
if [ ! -z "${extractComponentXmlFolder}" ] && [ null != "${extractComponentXmlFolder}" ] && [ "" != "${extractComponentXmlFolder}" ]
then
  	folder="${GITHUB_WORKSPACE}/${extractComponentXmlFolder}"
   	packageFolder="${folder}/${saveComponentId}"

 	mkdir -p "$packageFolder"
	
  # save the list of component details for a codereview report to be published at the end
	printf "%s%s%s\n" "${saveComponentId}|" "${saveComponentName}|" "${saveComponentVersion}" >> "${GITHUB_WORKSPACE}/${extractComponentXmlFolder}/${extractComponentXmlFolder}.list"
	echov "Publishing package metatdata for ${packageId}."
	source ${GITHUB_WORKSPACE}/cli/scripts/bin/publishPackagedComponentMetadata.sh packageIds="${packageId}" > "${packageFolder}/Manifest_${saveComponentId}.html"
	g=0
	export baseFolder="${packageFolder}"

	for g in ${!componentIds[@]}; 
	do
		componentId=${componentIds[$g]}
		componentVersion=${componentVersions[$g]}

		echo $componentId : $componentVersion

		source ${GITHUB_WORKSPACE}/cli/scripts/bin/getComponent.sh componentId=${componentId} version=${componentVersion} 
    		eval `cat "${GITHUB_WORKSPACE}"/${componentIds[$g]}.xml | xmllint --xpath '//*/@folderFullPath' -`
    		mkdir -p "${packageFolder}/${folderFullPath}"
		type=$(cat "${GITHUB_WORKSPACE}"/${componentIds[$g]}.xml | xmllint --xpath 'string(//*/@type)' -)
		
		# create extension file for this process
		if [ $type == "process" ] 
		then
			componentFile="${GITHUB_WORKSPACE}"/${componentIds[$g]}.xml
			source ${GITHUB_WORKSPACE}/cli/scripts/bin/createExtensionsJson.sh componentFile="${componentFile}"
		fi
 
    		mv "${GITHUB_WORKSPACE}"/${componentIds[$g]}.xml "${packageFolder}/${folderFullPath}" 
 	done
  
  	# Create a violations report using sonarqube rules	
	$GITHUB_WORKSPACE/cli/scripts/bin/xpathRulesChecker.sh baseFolder="${packageFolder}" > "${packageFolder}/ViolationsReport_${saveComponentId}.html"

	#$WD/bin/xpathRulesChecker.sh baseFolder="${packageFolder}"
	export baseFolder="${packageFolder}"
	#echo savenotes: ${saveNotes}

	source $GITHUB_WORKSPACE/cli/scripts/bin/gitPush.sh ${gitComponentOption}
 
 	#for _compIdx in ${!componentIds[@]}; 
	#do
 	#	componentId=${componentIds[$_compIdx]}
	#	componentVersion=${componentVersions[$_compIdx]}

 		#compNotesPre=$(echo $saveNotes | awk -v _fIdx=$_compIdx -F"," '{ print $_fIdx }')
   		#compNotesPost=$(echo $saveNotes | cut -f2 -d":")
     	#	compNotes="$componentId ($componentVersion)"
       	#	export compNotes
	 
	#	source $GITHUB_WORKSPACE/cli/scripts/bin/gitPush.sh ${gitComponentOption}
 	#done
  
	#export tag="${componentId}"
 	#export tag="${processName}"
	#export notes="Created from GitHub Actions Pipeline"
	#source $WD/bin/gitPush.sh "${notes}" "${tag}"

fi

clean

unset folder packageFolder
export packageId=${savePackageId}


if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
