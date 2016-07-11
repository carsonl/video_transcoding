#!/bin/bash

NAME=`basename $(dirname $0)`
if [ "${NAME}" == "." ]; then
	NAME=`basename $(pwd)`
fi
DIRNAME=`dirname $0`
if [ "${DIRNAME}" == "." ]; then
	DIRNAME=`pwd`
fi

#The below if block is not required, as it is always in debug mode for this container
TYPE="-i -t"
EXTRA="/bin/bash"
#if [ "${1}" == "debug" ]; then
#	TYPE="-i -t"
#	EXTRA="/bin/bash"
#	shift
#else
#	TYPE="-d"
#	EXTRA=""
#fi

if [ ! -d "$1" ]; then
	echo You need to specify a directory to pass in as a volume
	exit
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
docker run \
	--name ${NAME} \
	${TYPE} \
	\
	-v $1:$1 \
	\
	gadjet/${NAME}:latest \
	${EXTRA}

docker ps -a | grep -E 'gadjet/'${NAME}'|^CONTAINER'
