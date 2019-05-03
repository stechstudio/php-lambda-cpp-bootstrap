SHELL := /bin/bash

PROJ_ROOT ?= ${PWD}

aws-lambda-sdk:
	mkdir -p ${PROJ_ROOT}/out && \
	cd ${PROJ_ROOT}/build-aws-sdk && \
	cmake ${PROJ_ROOT}/aws-lambda-cpp -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${PROJ_ROOT}/out
