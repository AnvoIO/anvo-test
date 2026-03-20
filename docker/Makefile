IMAGE_NAME=ghcr.io/anvo-network/anvo-test
IMAGE_VERSION=latest
ARCH=$(shell uname -m)

build_snapshots:
	docker build -f Dockerfile.snapshot -t anvo-snapshot . --platform linux/$(ARCH)

create_snapshots: stop
	docker run --name qsnapshot \
		--env ANVO_PUB_KEY=EOS5dUsCQCAyHVjnqr6BFqVEE7w8XksnkRtz22wd9eFrSq4NHoKEH \
		--env ANVO_PRV_KEY=5JKxAqBoQuAYSh6YMcjxcougPpt1pi9L4PyJHwEQuZgYYgkWpjS \
		-d -p 8888:8888 anvo-snapshot:latest

copy_snapshots:
	./copy_snapshot.sh

build:
	docker buildx build -f Dockerfile -t $(IMAGE_NAME):$(IMAGE_VERSION) \
		--platform linux/amd64,linux/arm64 . --push

start: stop
	docker run --name anvotest --env SYSTEM_TOKEN_SYMBOL="ANVO" -d -p 8888:8888 $(IMAGE_NAME):$(IMAGE_VERSION)

stop:
	docker container rm anvotest -f 2>/dev/null || true
	docker container rm qsnapshot -f 2>/dev/null || true

push-docker:
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):latest
