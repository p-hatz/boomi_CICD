#Boomi Account Properties
export accountId="$1"
export authToken="$2:$3"
#Account Authorization (using an Atomsphere API Token)
export baseURL=https://api.boomi.com/api/rest/v1/$accountId
#Do not set 
export sonarRulesFile="$WD/conf/BoomiSonarRules.xml"

export gitComponentRepoURL="$4"
export gitComponentUserName="$5"
export gitComponentUserEmail="$6"
export gitComponentRepoName="$7" # Top level folder of the GIT REPO
export gitComponentOption="CLONE" # This clones the repo; else default is to create a release tag. Check gitPush.sh file
#export gitComponentCommitPath="/tree/master/" # For Azure Repos use this "?version=GBmaster&path=" this is used in code review report to construct the path
#export gitCLIRepoName="BoomiCLI" # Name of this repo in CLI this will be used in AzureReleasePipeline task
#export gitReleaseRepoName="BoomiRelease"

#Code Constants
export h1="Content-Type: application/json"
#Do not set
export h2="Accept: application/json"
#Do not set
#export WORKSPACE=`pwd`
#export WORKSPACE=${WD}
#Do not set
export VERBOSE="true"
#Enables verbose logging, set to false if you do not want the previously mentioned logs

#for xmllint
export PATH=$PATH:/usr/bin/
