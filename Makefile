REGISTRY_ENDPOINT ?= localhost:5001/
GOLANG_VERSION ?= 1.17.3
VERSION ?= v0.1.0-rc1
PROJECT ?= project-name
BUILDER_NAME ?= multiarch_builder
BUILD_PLATFORMS ?= linux/arm64,linux/amd64
DOCKERFILE_PATH ?= docker/Dockerfile

start-local-registry:
	@docker run -d -p 5001:5000 --name registry registry:2

stop-local-registry:
	@docker rm -f registry

prepare-builder:
	@docker buildx create \
		--name ${BUILDER_NAME} \
		--driver-opt network=host \
		--use

build-image:
	@docker buildx build -t $(REGISTRY_ENDPOINT)$(PROJECT):$(VERSION) -f ${DOCKERFILE_PATH} \
		--build-arg GOLANG_VERSION=$(GOLANG_VERSION) \
		--build-arg PROJECT_NAME=$(PROJECT) \
		--platform linux/arm64,linux/amd64 \
		--push \
		.

builder-cleanup:
	@docker buildx rm ${BUILDER_NAME} && docker buildx prune -fa

build: | prepare-builder build-image builder-cleanup
