VERSION := $(shell cat VERSION)

.PHONY: build
build:
	docker build -t carlsverre/damn-simple-dns-proxy .

.PHONY: test
test: build
	./test.sh

.PHONY: push
push: build
	docker tag carlsverre/damn-simple-dns-proxy carlsverre/damn-simple-dns-proxy:$(VERSION)
	docker push carlsverre/damn-simple-dns-proxy:$(VERSION)
