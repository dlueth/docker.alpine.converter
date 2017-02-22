IMAGE  = qoopido/converter
tag   ?= develop

build:
	docker build --no-cache=true -t ${IMAGE}:${tag} .

run:
	docker run --rm --name debug -it ${IMAGE}:${tag} /bin/sh
