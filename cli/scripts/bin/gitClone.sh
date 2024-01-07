#!/bin/bash

#source $WD/bin/common.sh
SCRIPTS_FOLDER=`pwd`

notes="Update"

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
#cp -R "${baseFolder}"/* "${gitComponentRepoName}"
cp -R "${baseFolder}"/* "${_repoName}"
#cd "${gitComponentRepoName}"
cd "${_repoName}"

#cp -R "${baseFolder}"/* "${_repoName}/${gitComponentRepoName}"
#cd "${gitComponentRepoName}"


git add .
#git commit -m "Update"
git commit -m "${notes}"
#git tag -a "${tag}" -m "${notes}"
git push 

cd "${SCRIPTS_FOLDER}"
#rm -rf "${gitComponentRepoName}" "${baseFolder}"
#rm -rf "${_repoName}" "${baseFolder}" "${gitComponentRepoName}"
