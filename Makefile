IMAGE  = qoopido/converter
tag   ?= develop

build:
	docker build --no-cache=true -t ${IMAGE}:${tag} .