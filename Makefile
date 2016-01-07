name=dockopscenter
registry=alexrudd
tag=5.2.3
ver=5.2.3

default: run

run: stop
	docker run \
	--name=${name} \
	-d \
	-p 8888:8888 \
	${registry}/${name}:${tag}

runt:
	docker run \
	--rm \
	-ti \
	-p 8888:8888 \
	${registry}/${name}:${tag}

stop:
	docker rm -f `docker ps -a | grep ${name} | head -n 1 | cut -d ' ' -f 1` || true

build:
	docker build --build-arg OPSCENTER_VERSION=${ver} -t ${registry}/${name}:${tag} .

pull:
	docker pull ${registry}/${name}:${tag}

push:
	docker push ${registry}/${name}:${tag}

logs:
	@docker logs `docker ps | grep ${name} | head -n 1 | cut -d ' ' -f 1`

logsf:
	@docker logs -f `docker ps | grep ${name} | head -n 1 | cut -d ' ' -f 1`

attach:
	docker exec -ti `docker ps | grep ${name} | head -n 1 | cut -d ' ' -f 1` /bin/sh
