IMG = github.com/ad/template-golang
TAG = latest

SRC_DIRS := . 

GOCACHE ?= $$(pwd)/.go/cache

CWD = $(shell pwd)
VER = $(shell git describe --tags --always --dirty)

export DOCKER_SCAN_SUGGEST := false
export IMG := $(IMG)
export TAG := $(TAG)
export VER := $(VER)
export CWD := $(CWD)

lint:
	@-docker run --rm -t -w $(CWD) -v $(CURDIR):$(CWD) -e GOFLAGS=-mod=vendor \
		golangci/golangci-lint:v1.42.1 golangci-lint run -v

test:
	@-chmod +x ./test.sh 
	@-docker run \
		--rm -i \
		-u $$(id -u):$$(id -g) \
		-e GOCACHE=/tmp/ \
		-w $(CWD) \
		-v $(CURDIR):$(CWD) \
		-v $(GOCACHE):/.cache \
		golang:alpine \
		/bin/sh -c " \
			./test.sh $(SRC_DIRS) \
		"

clean:
	@docker-compose rm -sfv

dev:
	@docker-compose up -d --build --remove-orphans
	@docker-compose logs -f

down:
	@docker-compose down