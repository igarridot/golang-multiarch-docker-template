# Golang Multiarch Docker Image Template

Simple template repo to build multiple CPU architecture Docker image for applications written in Go.

## What is this?

A `Makefile + Docker buildx + Dockerfile` workflow to build multiarchitecture Docker image containig Go binaries.
Every individual architecture image contains proper Go binary based on the CPU architecture.

## Requirements

- make
- Docker
- Docker buildx

## Key features

- Run local registry inside local Docker container
- Variables to manage project name, Go version and architectures to compile easily.

## How it works?

Following the [Docker Multistage](https://docs.docker.com/develop/develop-images/multistage-build/) best practices and [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/) [multiarchitecture](https://docs.docker.com/desktop/multi-arch/) approach.

## Configuration

Inside Makefile you can tune the following variables to build your project:

- REGISTRY_ENDPOINT: where to push the final image. By default points to local registry, which can be deployed using the Makefile. As standard Docker daemon doesn't support to save different CPU architecture images, we need to store them in a registry. Yoy can use any container repository instead of the local one.

- GOLANG_VERSION: which version of Go do you want to use to compile your project. By default `1.17.3`

- VERSION: your application version.

- PROJECT: your project name.

- BUILDER_NAME: assign a name to the container where we'll build the multiarch docker image. By default, `multiarch_builder`

- BUILD_PLATFORMS: list of CPU platforms to build the image. By default, `linux/arm64,linux/amd64`

- DOCKERFILE_PATH: where your Dockerfile is. By default, `docker/Dockerfile`

## Example of use

### To local registry

In this example case this is the flow to build a multiarch image and push it to the local registry:

- Copy your Go code inside `src` directory
- Start the local registry container: `make start-local-registry`
- Launch the build command: `make build`

This is it. You can run the following command to stop your local registry, which will remove your previously built images.

`make stop-local-registry`

### To remote registry

In this example case, we will build and push the multiarch image to a remote registry:

- Copy your Go code inside `src` directory
- Change `REGISTRY_ENDPOINT` variable value in Makefile, for example, to Docker Hub: `REGISTRY_ENDPOINT ?= yourRegistryUserName/`
- Launch the build command: `make build`

Result:
