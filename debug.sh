#!/bin/bash

NAME=`basename $(dirname $0)`
if [ "${NAME}" == "." ]; then
	NAME=`basename $(pwd)`
fi

if [ "$*" == "" ]; then
	docker exec -i -t ${NAME} bash
else
	docker exec -i -t ${NAME} $*
fi
