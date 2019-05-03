SHELL := /bin/bash

PROJ_ROOT ?= ${PWD}
MAKE_INSTALL_PREFIX ?= ${PROJ_ROOT}/out

configure-aws-lambda:
	mkdir -p ${PROJ_ROOT}/out && \
	cd ${PROJ_ROOT}/build-aws-sdk && \
	cmake ${PROJ_ROOT}/aws-lambda-cpp \
		-DCMAKE_BUILD_TYPE=Release \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_INSTALL_PREFIX=${MAKE_INSTALL_PREFIX}

make-aws-lambda:
	cd ${PROJ_ROOT}/build-aws-sdk && $(MAKE)

install-aws-lambda: make-aws-lambda
	cd ${PROJ_ROOT}/build-aws-sdk && $(MAKE) install

configure:
	cd ${PROJ_ROOT}/build && \
	cmake ${PROJ_ROOT}/bootstrap \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_PREFIX_PATH=${MAKE_INSTALL_PREFIX}
