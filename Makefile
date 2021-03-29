#!/usr/bin/make -f

# docker
IMAGE := $(shell basename $(shell pwd))
VERSION := latest

# composer: github token
COMPOSER_PATH:=$(shell which composer)
ifdef COMPOSER_PATH
	GITHUB_ACCESS_TOKEN:=$(shell composer config -g github-oauth.github.com)
endif

.PHONY: all deps \
tests phpcs phpstan phpcbf coverage \
build destroy start stop shell

# docker image 相關
build:
ifdef GITHUB_ACCESS_TOKEN
	docker build -t=$(IMAGE):$(VERSION) --build-arg GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN) .
else
	@echo ">>> Not setting 'GITHUB_ACCESS_TOKEN=YOUR_TOKEN' ...";
	@exit 1
endif

destroy:
	docker image rm $(IMAGE):$(VERSION)

rebuild:destroy build

# docker container 相關
run:
	docker run --rm -it -p 8080:80 -v `pwd`:/var/www/html --name=dockerFilePractice $(IMAGE):$(VERSION) sh

start:
	docker run --rm -it -p 8080:80 -v `pwd`:/var/www/html --name=dockerFilePractice $(IMAGE):$(VERSION)

stop:
	docker container stop dockerFilePractice

shell:
	docker exec -it dockerFilePractice sh

docker-tests:
	docker run --rm -it -p 8080:80 -v `pwd`:/var/www/html --name=dockerFilePractice $(IMAGE):$(VERSION) tests

# docker 內執行
all: deps phpcs phpstan tests 

deps:
	composer install

tests:
	vendor/bin/phpunit --testdox tests

phpcs:
	vendor/bin/phpcs

phpstan:
	vendor/bin/phpstan analyse --memory-limit=-1

phpcbf:
	vendor/bin/phpcbf

server:
	php -S 0.0.0.0:80
