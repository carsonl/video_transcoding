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
		if [ "${1}" == "${INSTANCE:1}" ]; then
			MATCHED=1
		fi
		#Do this for each of them (or the match)
		#echo Name: ${NAME}, DirName: ${DIRNAME}, Instance: ${INSTANCE:1}, Counter: ${INSTANCECOUNT}.
		#For builds, we don't actually do anything.
	fi
done
if [ "${INSTANCECOUNT}" == "0" ]; then
	echo ${0}: No instances found, nothing was done. > /dev/null
fi

cd /var/scripts/docker/${NAME}

if [ -f already-disabled ]; then
	touch already-already-disabled
else
	touch already-disabled
fi

if [ -f disabled ]; then
	touch already-disabled
else
	touch disabled
fi

if [ -f $(dirname ${BASH_SOURCE[0]})/build-extra.sh ]; then
	$(dirname ${BASH_SOURCE[0]})/build-extra.sh ${1}
fi

if [ "${1}" == "--no-cache" ]; then
	NOCACHE="--no-cache"
else
	NOCACHE=""
fi

docker build $NOCACHE -t gadjet/${NAME}:latest -t gadjet/${NAME}:`date +%s` .

if [ -f already-disabled ]; then
	rm already-disabled
else
	rm disabled
fi

if [ -f already-already-disabled ]; then
	rm already-already-disabled
	touch already-disabled
fi

cd -
