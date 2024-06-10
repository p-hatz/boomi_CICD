#!/bin/bash

#source $WD/bin/common.sh
SCRIPTS_FOLDER=`pwd`

# mandatory arguments
#ARGUMENTS=(baseFolder tag notes)
ARGUMENTS=(baseFolder)

inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi						

#git config --global user.email "${gitComponentUserEmail}"
#git config --global user.name  "${gitComponentUserName}"

echo 1
git clone "${gitComponentRepoURL}"

_repoName=$(basename $gitComponentRepoURL)
#cp -R "${baseFolder}"/* "${gitComponentRepoName}"

cp -R "${baseFolder}"/* "${_repoName}"/CodeReview

cd "${_repoName}"
#cd "${gitComponentRepoName}"

#cp -R "${baseFolder}"/* "${_repoName}/${gitComponentRepoName}"
#cd "${gitComponentRepoName}"

echo 2
git add .
git commit -m "${saveNotes}"
#git tag -a "${tag}" -m "${notes}"
git push 

echo 3
cd "${SCRIPTS_FOLDER}"
#rm -rf "${gitComponentRepoName}" "${baseFolder}"
#echo removing ${_repoName} ${baseFolder} ${gitComponentRepoName}
rm -rf "${_repoName}" "${baseFolder}" "${gitComponentRepoName}"
