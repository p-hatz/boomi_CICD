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

git config --global user.email peter.antony@gmail.com
git config --global user.name  "Peter Antony"

git clone "${gitComponentRepoURL}"

_repoName=$(basename $gitComponentRepoURL)
#cp -R "${baseFolder}"/* "${gitComponentRepoName}"

cp -R "${baseFolder}"/* "${_repoName}"/CodeReview

cd "${_repoName}"
#cd "${gitComponentRepoName}"

#cp -R "${baseFolder}"/* "${_repoName}/${gitComponentRepoName}"
#cd "${gitComponentRepoName}"

git add .
git commit -m "${saveNotes}"
#git tag -a "${tag}" -m "${notes}"
git push 

cd "${SCRIPTS_FOLDER}"
#rm -rf "${gitComponentRepoName}" "${baseFolder}"
#echo removing ${_repoName} ${baseFolder} ${gitComponentRepoName}
rm -rf "${_repoName}" "${baseFolder}" "${gitComponentRepoName}"
