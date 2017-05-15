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
INSTANCECOUNT=0
for i in ${DIRNAME}/print-instance-args_*.sh ; do
	INSTANCE=`basename $i `   #Just the file
	INSTANCE=${INSTANCE:20}   #Remove the first 20 chars (print-instance-args_)
	INSTANCE="_"${INSTANCE:0:-3} #Remove the last  3 chars (.sh)
	if [ "${1}" == "main" ]; then
		set -- "" "${@:2}"
	fi
	if [ "${INSTANCE:1}" == "main" ]; then
		INSTANCE=""
	fi
	if [ "${INSTANCE:1}" == "*" ]; then
		break;
	else
		INSTANCECOUNT=` expr ${INSTANCECOUNT} + 1 `
	fi
	if [ "${1}" == "${INSTANCE:1}" -o "${1}" == "" ]; then
		if [ "${MATCHED}" == "1" ]; then
			break
		fi
		MATCHED=1
		#Do this for each of them (or the match)
		#echo Name: ${NAME}, DirName: ${DIRNAME}, Instance: ${INSTANCE:1}, Counter: ${INSTANCECOUNT}.
		if [ "${1}" == "${INSTANCE:1}" ]; then
			shift;
		fi
		docker logs -f ${NAME}${INSTANCE} --tail ${*:-"100"} 2>&1
		break
	fi
done
if [ "${MATCHED}" != "1" ]; then
	echo ERR: $0: You need to specify an instance name >&2
fi
if [ "${INSTANCECOUNT}" == "0" ]; then
	echo ERR: $0: No instances found, nothing was done. >&2
fi

