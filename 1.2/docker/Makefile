DOCKER_IMAGE_NAME := yamlio/yaml-spec-builder
DOCKER_IMAGE_TAG := 0.0.2
DOCKER_IMAGE := $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

default:

build:
	docker build -t $(DOCKER_IMAGE) .

push: build
	docker push $(DOCKER_IMAGE)
