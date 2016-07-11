#!/bin/bash

NAME=`basename $(dirname $0)`
if [ "${NAME}" == "." ]; then
	NAME=`basename $(pwd)`
fi

docker logs -f ${NAME}
