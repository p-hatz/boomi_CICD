#!/bin/bash
set -e
#source bin/common.sh

# mandatory arguments
ARGUMENTS=(baseFolder) 
inputs "$@"
if [ "$?" -gt "0" ]
then
    return 255;
fi

unzip -qn -d cli ./sonarQube/sonarscanner.zip

if [ ! -z ${sonarURL} ]
then
 echov "Running sonarscanner for components under ${baseFolder}."
 #if [ -z "${SONAR_HOME}" ]
 #then
 # unzip  -qn  ../../sonarqube/sonar-scanner*.zip
#	SONAR_HOME="./sonar-scanner-4.2.0.1873-linux"
 #fi 
 
 #cd "${SONAR_HOME}"/bin
 #./sonar-scanner \
#  -Dsonar.projectKey="${sonarProject}" \
  #-Dsonar.projectBaseDir="${baseFolder}" \
  #-Dsonar.sources="${baseFolder}" \
  #-Dsonar.host.url="${sonarHostURL}" \
  #-Dsonar.login="${sonarToken}"

  #find "${baseFolder}" -name "*.xml"

echo ${sonarProject}
echo ${sonarURL}
echo ${sonar}

 cd "${SONAR_HOME}"/bin
 ./sonar-scanner \
  -Dsonar.projectKey="${sonarProject}" \
  -Dsonar.projectBaseDir="${baseFolder}" \
  -Dsonar.sources="${baseFolder}" \
  -Dsonar.host.url="${sonarURL}" \
  -Dsonar.login="${sonar}" > /dev/null
 
 cd "${WORKSPACE}"    
fi

clean
