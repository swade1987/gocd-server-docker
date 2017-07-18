APP_NAME=gocd-server
CURRENT_WORKING_DIR=$(shell pwd)

QUAY_REPO=swade1987
QUAY_USERNAME=swade1987
QUAY_PASSWORD?="unknown"

GO_PIPELINE_COUNTER?="unknown"

# Construct the image tag.
VERSION=1.1.$(GO_PIPELINE_COUNTER)

# Construct docker image name.
IMAGE = quay.io/$(QUAY_REPO)/$(APP_NAME)

build: build-image

push: docker-login push-image docker-logout

deploy-dev: helm-package deploy

build-image:
	docker build \
    --build-arg git_repository=`git config --get remote.origin.url` \
    --build-arg git_branch=`git rev-parse --abbrev-ref HEAD` \
    --build-arg git_commit=`git rev-parse HEAD` \
    --build-arg built_on=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    -t $(IMAGE):$(VERSION) .

docker-login:
	docker login -u $(QUAY_USERNAME) -p $(QUAY_PASSWORD) quay.io

docker-logout:
	docker logout

push-image:
	docker push $(IMAGE):$(VERSION)
	docker rmi $(IMAGE):$(VERSION)