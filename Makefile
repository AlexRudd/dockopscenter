name=dockopscenter
registry=alexrudd
version=0.1

default: run

run:
	docker run \
	--name=${name} \
	-dP \
	${registry}/${name}:${version}

runt:
	docker run \
	--rm \
	-tiP \
	${registry}/${name}:${version}

stop:
	docker rm -f `docker ps -a | grep ${name} | head -n 1 | cut -d ' ' -f 1` || true

build:
	docker build -t ${registry}/${name}:${version} .

pull:
	docker pull ${registry}/${name}:${version}

push:
	docker push ${registry}/${name}:${version}

logs:
	@docker logs `docker ps | grep ${name} | head -n 1 | cut -d ' ' -f 1`

logsf:
	@docker logs -f `docker ps | grep ${name} | head -n 1 | cut -d ' ' -f 1`

attach:
	docker exec -ti `docker ps | grep ${name} | head -n 1 | cut -d ' ' -f 1` /bin/bash
