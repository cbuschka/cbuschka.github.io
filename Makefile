PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
VENV_DIR := ${PROJECT_DIR}/venv/
OUTPUT_DIR := ${PROJECT_DIR}/../cbuschka.github.io
SHELL := /bin/bash

init:
	echo Project dir is $(PROJECT_DIR)
	if [ ! -d "${VENV_DIR}" ]; then \
		virtualenv ${VENV_DIR}; \
		make -f ${PROJECT_DIR}/Makefile update_packages; \
	fi

serve:	init patch
	source ${VENV_DIR}/bin/activate && \
	PYTHONDONTWRITEBYTECODE=1 pelican --listen --autoreload --port 8000

update_packages:	init
	source ${VENV_DIR}/bin/activate; \
	pip install -r ${PROJECT_DIR}/requirements.txt

patch:	init
	cp -R ${PROJECT_DIR}/theme-patches/* ${PROJECT_DIR}/theme/

build:	init patch
	if [ ! -d "${OUTPUT_DIR}" ]; then echo "${OUTPUT_DIR} missing!"; exit 1; fi
	source ${VENV_DIR}/bin/activate && \
	PYTHONDONTWRITEBYTECODE=1 pelican -o ${OUTPUT_DIR}

#build_with_docker:
#	docker run --rm \
#		-u $(shell id -u):$(shell id -g) \
#		-v ${PROJECT_DIR}:/work/cbuschka.github.io-sources \
#		-v ${OUTPUT_DIR}:/work/cbuschka.github.io \
#		-w /work/cbuschka.github.io-sources \
#		python:3.8 make build
