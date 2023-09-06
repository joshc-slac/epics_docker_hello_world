SHELL:=/bin/bash
VERSION=0x03

.PHONY: build
build:
	@docker build --tag epics_rhel_hello_world .

.PHONY: run
run:
	@docker run -it --rm --hostname ctl-wtf-cam-03 epics_rhel_hello_world bash || true
