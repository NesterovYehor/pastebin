# Project variables
MODULE_NAME := github.com/NesterovYehor/pastebin
DOCKER_COMPOSE := docker-compose.yml
GO_FILES := $(shell find . -name '*.go' -not -path "./vendor/*")

# Go commands
.PHONY: all build run test lint fmt tidy clean docker-up docker-down

all: build

# Build the Go project
build:
	go build -o bin/server cmd/api/main.go

# Run the Go project
run: build
	./bin/server

# Run all tests
test:
	go test -v ./...

# Lint the code (requires golangci-lint)
lint:
	@golangci-lint run ./...

# Format Go code
fmt:
	go fmt ./...

# Tidy up dependencies
tidy:
	go mod tidy

# Clean build artifacts
clean:
	rm -rf bin/*

# Run Docker Compose to start all services
docker-up:
	docker-compose -f $(DOCKER_COMPOSE) up -d

# Stop and remove Docker Compose services
docker-down:
	docker-compose -f $(DOCKER_COMPOSE) down

# Rebuild Docker images
docker-build:
	docker-compose -f $(DOCKER_COMPOSE) build

# Run Go code with live reloading (requires air)
dev:
	@command -v air >/dev/null 2>&1 || { echo "Please install air for live reloading (https://github.com/cosmtrek/air)"; exit 1; }
	air -c .air.toml

