#!/bin/bash
source bin/common.sh

export WORKSPACE=/tmp

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
		source "${GITHUB_WORKSPACE}/cli/scripts/bin/queryComponentMetadata.sh" componentName="${processName}" componentType="${componentType}" componentId="${componentId}" componentVersion="${componentVersion}" currentVersion="" deleted=""
		saveComponentName="${componentName}"
        saveComponentId="${componentId}"
        saveComponentVersion="${componentVersion}"
		source "${GITHUB_WORKSPACE}/cli/scripts/bin/createPackagedComponent.sh" componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion="${componentVersion}"
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
	source "${GITHUB_WORKSPACE}/cli/scripts/bin/queryComponentMetadata.sh" componentName="${processName}" componentType="${componentType}" componentId="${componentId}" componentVersion="${componentVersion}" currentVersion="" deleted="" 
	
	saveComponentName="${componentName}"
    saveComponentVersion="${componentVersion}"
	componentId="${saveComponentId}"
	source "${GITHUB_WORKSPACE}/cli/scripts/bin/createPackagedComponent.sh" componentId=${componentId} componentType="${componentType}" packageVersion="${packageVersion}" notes="${notes}" componentVersion="${componentVersion}"
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
	folder="${WORKSPACE}/${extractComponentXmlFolder}"
	packageFolder="${folder}/${saveComponentId}"
	#for some reason we get directories created with a CR in it
	cleanUUID=$(echo "$saveComponentId" | tr -d '\r')
	packageFolder="${folder}/${cleanUUID}"
	mkdir -p "${packageFolder}"
	
  # save the list of component details for a codereview report to be published at the end
	printf "%s%s%s\n" "${saveComponentId}|" "${saveComponentName}|" "${saveComponentVersion}" >> "${WORKSPACE}/${extractComponentXmlFolder}/${extractComponentXmlFolder}.list"
	echov "Publishing package metatdata for ${packageId}."
	source "${GITHUB_WORKSPACE}/cli/scripts/bin/publishPackagedComponentMetadata.sh" packageIds="${packageId}" > "${packageFolder}/Manifest_${saveComponentId}.html"
  	g=0
	export baseFolder="${packageFolder}"

	for g in ${!componentIds[@]}; 
	do
 		componentId=${componentIds[$g]}
		componentVersion=${componentVersions[$g]}

		echo componentId version: $componentId : $componentVersion
  		source ${GITHUB_WORKSPACE}/cli/scripts/bin/getComponent.sh componentId=${componentId} version=${componentVersion} 
    	eval `cat "${WORKSPACE}"/${componentIds[$g]}.xml | xmllint --xpath '//*/@folderFullPath' -`
    	mkdir -p "${packageFolder}/${folderFullPath}"
      	type=$(cat "${WORKSPACE}"/${componentIds[$g]}.xml | xmllint --xpath 'string(//*/@type)' -)
		
		# create extension file for this process
		echo Processing extensions
		if [ $type == "process" ] 
		then
			componentFile="${WORKSPACE}"/${componentIds[$g]}.xml
			source ${GITHUB_WORKSPACE}/cli/scripts/bin/createExtensionsJson.sh componentFile="${componentFile}"
		fi
 
    	mv "${WORKSPACE}"/${componentIds[$g]}.xml "${packageFolder}/${folderFullPath}"
      	#echo Listing "${packageFolder}/${folderFullPath}"
 	done

	if [ "${codeCheck}" -eq 1 ]
	then
		source ${GITHUB_WORKSPACE}/cli/scripts/bin/sonarScanner.sh baseFolder="${packageFolder}"
  		# Create a violations report using sonarqube rules	
		source ${GITHUB_WORKSPACE}/cli/scripts/bin/xpathRulesChecker.sh baseFolder="${packageFolder}" > "${packageFolder}/ViolationsReport_${saveComponentId}.html"

		#$WD/bin/xpathRulesChecker.sh baseFolder="${packageFolder}"
		export baseFolder="${packageFolder}"
		echo savenotes: ${saveNotes}

		export $saveNotes
		source ${GITHUB_WORKSPACE}/cli/scripts/bin/gitPush.sh ${gitComponentOption}
		#export tag="${componentId}"
 		#export tag="${processName}"
		#export notes="Created from GitHub Actions Pipeline"
		#source $WD/bin/gitPush.sh "${notes}" "${tag}"
	
		#need to wait until Sonar is ready
		sleep 5
		_url="${sonarURL}/api/issues/search?project=Boomi&issueStatuses=OPEN"
		_issues=$(curl -s -u "$sonar:" "$_url")
 		_issueCount=0
		_issueCount=$(echo $_issues | jq -r ".total")
   		echo issueCount: $_issueCount
    	if [ "$_issueCount" -ne "0" ]
    	then
    		echo Issues found with scan!
			clean
    		return 255
		else
 			echo No issues. Continuing...
   		fi
	else
		echo Skipping code Check
	fi
fi

clean

unset folder packageFolder
export packageId=${savePackageId}

if [ "$ERROR" -gt 0 ]
then
   return 255;
fi
