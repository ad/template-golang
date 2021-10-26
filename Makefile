.EXPORT_ALL_VARIABLES:
DOCKER_SCAN_SUGGEST = false
SRC_DIRS := . 
CWD = $(shell pwd)
IMG = github.com/ad/template-golang
TAG = latest
GOCACHE ?= $$(pwd)/.go/cache
VERSION = $(shell git describe --tags --always --abbrev=0 --match='v[0-9]*.[0-9]*.[0-9]*' 2> /dev/null | sed 's/^.//')
COMMIT_HASH = $(shell git rev-parse --short HEAD)
BUILD_TIMESTAMP = $(shell date '+%Y-%m-%dT%H:%M:%S')


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