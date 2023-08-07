#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomId workerMaxExecutionTime workerMaxRunningExecutions workerQueuedExecutionTimeout enableAtomWorkerWarmup httpWorkload minNumberofAtomWorkers numberofAtomWorkers)
JSON_FILE=json/accountCloudAttachmentProperties.json
URL=$baseURL/AccountCloudAttachmentProperties/${atomId}
id=id
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi


createJSON

callAPI

clean
if [ "$ERROR" -gt "0" ]
then
   printf "Error"
fi
