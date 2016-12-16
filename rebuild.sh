#!/bin/bash

NAME=`basename $( dirname ${BASH_SOURCE[0]} )`
if [ "${NAME}" == "." ]; then
	NAME=`basename $(pwd)`
fi
DIRNAME=`dirname ${BASH_SOURCE[0]}`
DIRNAME=`readlink -f ${DIRNAME}`
if [ "${DIRNAME}" == "." ]; then
	DIRNAME=`pwd`
fi

cd /u01/repos/srv/docker/${NAME}

if [ -f disabled ]; then
	touch already-disabled
else
	touch disabled
fi

echo Stopping/Killing/Removing: ${NAME}
/u01/repos/srv/docker/${NAME}/rm.sh

echo Removing existing images for: ${NAME}
docker images -a --format "{{.Repository}}:{{.Tag}}" gadjet/${NAME} | xargs --no-run-if-empty docker rmi

echo Building: ${NAME}
/u01/repos/srv/docker/${NAME}/build.sh

if [ -f already-disabled ]; then
	rm already-disabled
else
	rm disabled
fi

cd -
