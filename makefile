OWNER=rajatvig
IMAGE_NAME=local-dynamo-alpine
QNAME=$(OWNER)/$(IMAGE_NAME)

GIT_TAG=$(QNAME):$(CIRCLE_SHA1)
BUILD_TAG=$(QNAME):0.1.0-b$(CIRCLE_BUILD_NUM)
LATEST_TAG=$(QNAME):latest

stop:
	docker stop $(IMAGE_NAME)

clean: stop
	docker rmi $(QNAME):local

build: stop
	docker build -t $(QNAME):local .

run:
	docker rm local-dynamo-alpine
	docker run -d -p 8000:8000 --name=$(IMAGE_NAME) $(QNAME):local

tag:
	docker tag $(GIT_TAG) $(BUILD_TAG)
	docker tag $(LATEST_TAG) $(BUILD_TAG)

login:
	@docker login -u "$(DOCKER_USER)" -p "$(DOCKER_PASS)"

push: login
	docker push $(GIT_TAG)
	docker push $(BUILD_TAG)
	docker push $(LATEST_TAG)