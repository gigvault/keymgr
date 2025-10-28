.PHONY: build test lint docker run-local clean

build:
	go build -o bin/keymgr ./cmd/keymgr

test:
	go test ./... -v

lint:
	golangci-lint run ./...

docker:
	docker build -t gigvault/keymgr:local .

run-local: docker
	../infra/scripts/deploy-local.sh keymgr

clean:
	rm -rf bin/
	go clean
