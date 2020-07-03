EXECUTABLE=ignore
WINDOWS=build/$(EXECUTABLE)_windows_amd64.exe
LINUX=build/$(EXECUTABLE)_linux_amd64
DARWIN=build/$(EXECUTABLE)_darwin_amd64

VERSION ?= $(shell cat ./VERSION)

export GO111MODULE=on

.PHONY: version
version:
	$(shell git tag -f $(VERSION))
	@echo $(VERSION)
test: # Run go tests
	go test -v ./...

lint: # Run golint
	golint -set_exit_status ./...

windows: $(WINDOWS) ## Build for Windows

linux: $(LINUX) ## Build for Linux

darwin: $(DARWIN) ## Build for Darwin (macOS)

$(WINDOWS):
	env GOOS=windows GOARCH=amd64 go build -i -v -o $(WINDOWS) -ldflags="-s -w -X main.version=$(VERSION)"  .

$(LINUX):
	env GOOS=linux GOARCH=amd64 go build -i -v -o $(LINUX) -ldflags="-s -w -X main.version=$(VERSION)"  .

$(DARWIN):
	env GOOS=darwin GOARCH=amd64 go build -i -v -o $(DARWIN) -ldflags="-s -w -X main.version=$(VERSION)"  .

build: windows linux darwin ## Build binaries
	@echo $(WINDOWS)
	@echo version: $(VERSION)

clean: ## Remove build binaries
	rm -rf ./dist ./build


.PHONY: all test clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

pre-release:
	goreleaser --snapshot --skip-publish --rm-dist

release:
	goreleaser

all: test lint build clean
