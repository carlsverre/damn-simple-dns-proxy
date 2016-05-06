.PHONY: build
build:
	GOOS=linux ARCH=amd64 go build -o dsdp .
	docker build -t carlsverre/damn-simple-dns-proxy .

.PHONY: test
test: build
	./test.sh

.PHONY: push
push: build
	docker push carlsverre/damn-simple-dns-proxy
