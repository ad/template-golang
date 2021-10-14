IMG = github.com/ad/template-golang
TAG = latest

CWD = $(shell pwd)
VER = $(shell git describe --tags --always --dirty)

export DOCKER_SCAN_SUGGEST := false
export IMG := $(IMG)
export TAG := $(TAG)
export VER := $(VER)
export CWD := $(CWD)

# test:
# 	@docker run --rm -v $(CWD):$(CWD) -w $(CWD) golang:alpine sh -c "CGO_ENABLED=0 go test -mod=vendor  -v"

lint:
	@-docker run --rm -t -w $(CWD) -v $(CURDIR):$(CWD) -e GOFLAGS=-mod=vendor \
		golangci/golangci-lint:v1.42.1 golangci-lint run -v

clean:
	@docker-compose rm -sfv

dev:
	@docker-compose up -d --build --remove-orphans
	@docker-compose logs -f

down:
	@docker-compose down