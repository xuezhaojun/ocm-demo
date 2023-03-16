SHELL :=/bin/bash

all: build
.PHONY: all

IMAGE_REGISTRY?=quay.io/open-cluster-management
IMAGE_TAG?=latest

# Build image seperately.
build-registration:
	go build -o registration ./cmd/registration

image-registration:
	docker build \
		-f Dockerfile.registration \
		-t $(IMAGE_REGISTRY)/registration:$(IMAGE_TAG) .

# Build an all-in-one image.
# TODO: placement have dependency conflict with other repos, need to fix it first.
build-all:
	go build -o registration ./cmd/registration
	go build -o work ./cmd/work
	go build -o registration-operator ./cmd/registration-operator

images:
	docker build \
		-f Dockerfile \
		-t $(IMAGE_REGISTRY)/ocm:$(IMAGE_TAG) .

# Build an overall e2e test for all components.
build-e2e:
	go test -c -o e2e.test ./test/e2e

test-e2e: build-e2e
	./e2e.test