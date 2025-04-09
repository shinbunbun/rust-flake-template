# linuxかmacかでdockerのsockのパスを変える
ifeq ($(shell uname), Darwin)
DOCKER_SOCK=$(HOME)/.docker/run/docker.sock
else
DOCKER_SOCK=/var/run/docker.sock
endif

PROJECT_NAME := $(shell basename $(shell pwd))

init:
	@echo ">>> project_name.txt を更新します"
	@echo "$(PROJECT_NAME)" > project_name.txt
	@echo "project_name.txt に '$(PROJECT_NAME)' を書き込みました。"

dev-env:
	@$(MAKE) build-dev-env-container
	@$(MAKE) load-dev-env-container

build-dev-env-container:
	docker build -t build-docker-temp .

load-dev-env-container:
	docker run --rm \
	-v $(DOCKER_SOCK):/var/run/docker.sock \
	-v $(shell pwd):/workspace \
	-it build-docker-temp
	docker image rm -f build-docker-temp

exec-dev-env-container:
	docker run --rm -it ${PROJECT_NAME}:latest
