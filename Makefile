IMAGE_REGISTRY=youtube-ex/youtube-ex
IMAGE_VERSION=0.1.0

all: image

.PHONY: compile
compile:
	mix compile

.PHONY: image
image:
	docker build \
		--build-arg APP_NAME=youtube-ex \
		--build-arg APP_VSN=0.1.0 \
		-t ${IMAGE_REGISTRY}:latest \
		.

.PHONY: release
release:
	MIX_ENV=prod mix do deps.get,
	cd apps/youtube_ex_web/assets && \
		yarn install && \
		yarn deploy
	MIX_ENV=prod mix release --verbose

.PHONY: doc
doc:
	mix docs

.PHONY: publish
publish:
	docker push ${IMAGE_REGISTRY}:latest
