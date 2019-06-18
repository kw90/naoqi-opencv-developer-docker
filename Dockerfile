FROM python:2.7

# Install dependencies
RUN apt-get update && \
		apt-get install -y \
		python-pip \
		iproute2 \
		telnet \
		iputils-ping \
		wget\
		curl\
		build-essential\
		gcc \
		cmake \
		unzip \
		libenchant1c2a \
		libavformat-dev \
		libavcodec-dev \
		libavfilter-dev \
		libswscale-dev \
		libjpeg-dev \
		libpng-dev \
		libtiff-dev \
		zlib1g-dev \
		libopenexr-dev \
		libxine2-dev \
		libeigen3-dev \
		libtbb-dev && \
		rm -rf /var/lib/apt/lists/*

RUN pip install numpy paramiko

WORKDIR /opencv-build

RUN wget https://github.com/opencv/opencv/archive/3.4.6.zip

RUN unzip 3.4.6.zip && \
		mkdir opencv-3.4.6/release && \
		cd opencv-3.4.6/release && \
		cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
		make -j4 && make install && \
		cd / && rm -rf opencv-build

# Set the working directory to /naoqi
WORKDIR /naoqi

# Copy the NAOqi for Python SDK
ADD pynaoqi-python2.7-2.5.7.1-linux64.tar.gz /naoqi/

# Copy the boost fix
# See https://community.ald.softbankrobotics.com/en/forum/import-issue-pynaoqi-214-ubuntu-7956
ADD boost/* /naoqi/pynaoqi-python2.7-2.5.7.1-linux64/

# Set the path to the SDK
ENV PYTHONPATH=${PYTHONPATH}:/naoqi/pynaoqi-python2.7-2.5.7.1-linux64/lib/python2.7/site-packages/
ENV LD_LIBRARY_PATH="/naoqi/pynaoqi-python2.7-2.5.7.1-linux64:$LD_LIBRARY_PATH"

