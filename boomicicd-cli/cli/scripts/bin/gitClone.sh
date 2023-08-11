#!/bin/bash

source $WD/bin/common.sh
SCRIPTS_FOLDER=`pwd`

# mandatory arguments
ARGUMENTS=(baseFolder tag notes)

inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi						

#git config --global user.email "${gitComponentUserEmail}"
#git config --global user.name  "${gitComponentUserName}"

git clone "${gitComponentRepoURL}"
_repoName=$(basename $gitComponentRepoURL)
echo $baseFolder
echo $gitComponentRepoName
#cp -R "${baseFolder}"/* "${gitComponentRepoName}"
cp -R "${baseFolder}"/* "${_repoName}/${gitComponentRepoName}"
#cd "${gitComponentRepoName}"
cd "${_repoName}"
git add .
git commit -m "Update"
#git commit -m "${notes}"
#git tag -a "${tag}" -m "${notes}"
git push 

echo $SCRIPTS_FOLDER

cd "${SCRIPTS_FOLDER}"
#rm -rf "${gitComponentRepoName}" "${baseFolder}"
#rm -rf "${_repoName}" "${baseFolder}" "${gitComponentRepoName}"
