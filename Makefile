OWNER=rajatvig
IMAGE_NAME=local-dynamo-alpine
QNAME=$(OWNER)/$(IMAGE_NAME)

GIT_TAG=$(QNAME):$(TRAVIS_COMMIT)
BUILD_TAG=$(QNAME):0.2.$(TRAVIS_BUILD_NUMBER)
LATEST_TAG=$(QNAME):latest

build:
	docker build -t $(GIT_TAG) .

lint:
	docker run -it --rm -v "$(PWD)/Dockerfile:/Dockerfile:ro" redcoolbeans/dockerlint

tag:
	docker tag $(GIT_TAG) $(BUILD_TAG)
	docker tag $(GIT_TAG) $(LATEST_TAG)

run:
	docker-compose up --build

login:
	@docker login -u "$(DOCKER_USER)" -p "$(DOCKER_PASS)"

push: login
	docker push $(GIT_TAG)
	docker push $(BUILD_TAG)
	docker push $(LATEST_TAG)