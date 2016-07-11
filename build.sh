#!/bin/bash

NAME=`basename $(dirname $0)`
if [ "${NAME}" == "." ]; then
	NAME=`basename $(pwd)`
fi

DCID=`docker ps -q -a -f name=${NAME} -f status=running`
if [ "${DCID}" != "" ]; then
	docker stop ${DCID}
fi
DCID=`docker ps -q -a -f name=${NAME} -f status=running`
if [ "${DCID}" != "" ]; then
	docker kill ${DCID}
fi
DCID=`docker ps -q -a -f name=${NAME}`
if [ "${DCID}" != "" ]; then
	docker rm -v ${DCID}
fi
cd /u01/repos/srv/docker/${NAME}

if [ -f disabled ]; then
	touch already-disabled
else
	touch disabled
fi

if [ -f ./build-extra.sh ]; then
	./build-extra.sh
fi

if [ "${1}" == "--no-cache" ]; then
	NOCACHE="--no-cache"
else
	NOCACHE=""
fi

docker build $NOCACHE -t carsonl/${NAME}:latest -t carsonl/${NAME}:`date +%s` .

if [ -f already-disabled ]; then
	rm already-disabled
else
	rm disabled
fi

cd -
