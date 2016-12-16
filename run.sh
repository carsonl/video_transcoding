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
	if [ "${INSTANCE:1}" == "*" ]; then
		break;
	else
		INSTANCECOUNT=` expr ${INSTANCECOUNT} + 1 `
	fi
	INSTANCE=` basename $i `   #Just the file
	INSTANCE=${INSTANCE:20}   #Remove the first 20 chars (print-instance-args_)
	INSTANCE="_"${INSTANCE:0:-3} #Remove the last  3 chars (.sh)
	if [ "${1}" == "main" ]; then
		set -- "" "${@:2}"
	fi
	if [ "${INSTANCE:1}" == "main" ]; then
		INSTANCE=""
	fi
	if [ "${1}" == "${INSTANCE:1}" -o "${1}" == "" -o "${1}" == "debug" ]; then
		if [ "${1}" == "debug" ]; then
			echo ERR: $0: You need to specify an instance name >&2
			break
		fi
		if [ "${MATCHED}" == "1" ]; then
			break
		fi
		if [ "${1}" == "${INSTANCE:1}" ]; then
			MATCHED=1
			shift;
		fi
		#Do this for each of them (or the match)
		#echo Name: ${NAME}, DirName: ${DIRNAME}, Instance: ${INSTANCE:1}, Counter: ${INSTANCECOUNT}.
		if [ "${1}" == "debug" ]; then
			MATCHED=1
			shift;
			TYPE="-i -t"
			EXTRA="/bin/bash"
		else
			TYPE="-d"
			if [ "${1}" == "" ]; then
				EXTRA=""
			else
				EXTRA=${1}
			fi
		fi

		DCID=`docker ps -q -a -f name=${NAME}${INSTANCE}$ -f status=exited`
		if [ "${DCID}" != "" ]; then
			docker rm -v ${DCID}
		fi
		DCID=`docker ps -q -a -f name=${NAME}${INSTANCE}$ -f status=created`
		if [ "${DCID}" != "" ]; then
			docker rm -v ${DCID}
		fi

		DCID=`docker ps -q -a -f name=${NAME}${INSTANCE}$`
		if [ "${DCID}" != "" ]; then
			echo WARN ${0}: ${NAME}${INSTANCE} is already running, nothing was done. >&2
		else
			docker run \
				--name ${NAME}${INSTANCE} \
				${TYPE} \
				\
				` ${DIRNAME}/print-instance-args${INSTANCE:-"_main"}.sh ${INSTANCE:1} ` \
				\
				gadjet/${NAME}:latest \
				${EXTRA}
			docker ps -a -f name=${NAME}${INSTANCE}$
		fi
	fi
done
if [ "${INSTANCECOUNT}" == "0" ]; then
	echo ${0}: No instances found, nothing was done. >&2
fi




