#!/bin/bash
#source $WD/bin/common.sh

# mandatory arguments
ARGUMENTS=(packageVersion notes) 
OPT_ARGUMENTS=(componentId processName extractComponentXmlFolder componentVersion componentType)
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

# This is a trick to remove special characters in the value
notes="$(<<< "$notes" sed -e 's`[\\/^$&`\\]`\\&`g')"

folder="${WORKSPACE}/${extractComponentXmlFolder}"
saveNotes="${notes}"
saveComponentId="${componentId}"
savePackageVersion="${packageVersion}"
saveComponentType="${componentType}"
saveComponentVersion="${componentVersion}"
if [ -z "${componentId}" ] || [ null == "${componentId}" ]
then
	notes="${saveNotes}"
        packageVersion="${savePackageVersion}"
        processName=`echo "${processName}" | xargs`
        saveProcessName="${processName}"
        componentType="${saveComponentType}"
        componentId=""
	source $WD/bin/queryComponentMetadata.sh componentName="${processName}" componentType="${componentType}" componentId="${componentId}" componentVersion="${componentVersion}" currentVersion="" deleted=""
	saveComponentName="${componentName}"
        saveComponentId="${componentId}"
        saveComponentVersion="${componentVersion}"
	source $WD/bin/createPackagedComponent.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion="${componentVersion}"
	if [ ! -z ${packageId} ]
	then
		echoi "Created package ${packageId} for component ${saveProcessName}"
	else 
		return 255;
	fi 
else    
	notes="${saveNotes}"
        packageVersion="${savePackageVersion}"
        componentId="${saveComponentId}"
        #componentId=`echo "${componentId}" | xargs`
        saveComponentId="${componentId}"
        componentType="${saveComponentType}"
	processName=""
	source $WD/bin/queryComponentMetadata.sh componentName="${processName}" componentType="${componentType}" componentId="${componentId}" componentVersion="${componentVersion}" currentVersion="" deleted="" 
	saveComponentName="${componentName}"
        saveComponentVersion="${componentVersion}"
	componentId="${saveComponentId}"
	source $WD/bin/createPackagedComponent.sh componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion="${componentVersion}"
	if [ ! -z ${packageId} ]
	then
		echoi "Created package ${packageId} for componentId ${saveComponentId}"
	else 
		return 255;
	fi 
fi  

savePackageId=${packageId}

# Extract Boomi componentXMLs to a local disk
if [ ! -z "${extractComponentXmlFolder}" ] && [ null != "${extractComponentXmlFolder}" ] && [ "" != "${extractComponentXmlFolder}" ]
then
	echo Here1
  	folder="${WORKSPACE}/${extractComponentXmlFolder}"
	packageFolder="${folder}/${saveComponentId}"
	mkdir -p "${packageFolder}"
	
  # save the list of component details for a codereview report to be published at the end
	printf "%s%s%s\n" "${saveComponentId}|" "${saveComponentName}|" "${saveComponentVersion}" >> "${WORKSPACE}/${extractComponentXmlFolder}/${extractComponentXmlFolder}.list"
	echov "Publishing package metatdata for ${packageId}."
	source $WD/bin/publishPackagedComponentMetadata.sh packageIds="${packageId}" > "${packageFolder}/Manifest_${saveComponentId}.html"
  	g=0
	export baseFolder="${packageFolder}"

	for g in ${!componentIds[@]}; 
	do
 		echo LOOP!
		componentId=${componentIds[$g]}
		componentVersion=${componentVersions[$g]}

		#echo $componentId : $componentVersion
  		source $WD/bin/getComponent.sh componentId=${componentId} version=${componentVersion} 
    		eval `cat "${WORKSPACE}"/${componentIds[$g]}.xml | xmllint --xpath '//*/@folderFullPath' -`
    		mkdir -p "${packageFolder}/${folderFullPath}"
      		type=$(cat "${WORKSPACE}"/${componentIds[$g]}.xml | xmllint --xpath 'string(//*/@type)' -)
		
		# create extension file for this process
		if [ $type == "process" ] 
		then
			componentFile="${WORKSPACE}"/${componentIds[$g]}.xml
			source $WD/bin/createExtensionsJson.sh componentFile="${componentFile}"
		fi
 
    		mv "${WORKSPACE}"/${componentIds[$g]}.xml "${packageFolder}/${folderFullPath}"
      		echo Listing "${packageFolder}/${folderFullPath}"
 done
 	echo find...
	find $folder
  	$WD/bin/sonarScanner.sh baseFolder="${packageFolder}"
  # Create a violations report using sonarqube rules	
	$WD/bin/xpathRulesChecker.sh baseFolder="${packageFolder}" > "${packageFolder}/ViolationsReport_${saveComponentId}.html"

	#$WD/bin/xpathRulesChecker.sh baseFolder="${packageFolder}"
	export baseFolder="${packageFolder}"
	echo savenotes: ${saveNotes}

	export $saveNotes
	source $WD/bin/gitPush.sh ${gitComponentOption}
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
