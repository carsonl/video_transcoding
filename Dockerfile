FROM		ubuntu:trusty
MAINTAINER	Carson Longhorn <dockerfiles@unrelated.net.au>

ENV		DEBIAN_FRONTEND noninteractive
COPY		root/running_notes.txt /root/running_notes.txt

RUN		apt-get update && \
		apt-get -y install \
			software-properties-common \
		&& \
		add-apt-repository ppa:mc3man/trusty-media && \
		add-apt-repository ppa:stebbins/handbrake-releases && \
		apt-get update && \
		apt-get -y install \
			ffmpeg \
			frei0r-plugins \
			handbrake-cli \
			mencoder \
			mkvtoolnix \
			mp4v2-utils \
			mplayer2 \
			ruby2.0 \
			sshfs \
		&& \
		apt-get clean && \
		gem2.0 install video_transcoding

CMD		/bin/bash
