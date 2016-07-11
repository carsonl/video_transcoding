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
