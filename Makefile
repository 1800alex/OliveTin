define delete-files
	python -c "import shutil;shutil.rmtree('$(1)', ignore_errors=True)"
endef

service:
	$(MAKE) -wC service

service-prep:
	$(MAKE) -wC service prep

service-unittests:
	$(MAKE) -wC service unittests

service-codestyle:
	$(MAKE) -wC service codestyle

frontend-codestyle:
	$(MAKE) -wC frontend codestyle

it:
	$(MAKE) -wC integration-tests

go-tools:
	$(MAKE) -wC service go-tools

proto: go-tools
	$(MAKE) -wC proto

dist:
	echo "dist noop"


podman-image:
	buildah bud -t olivetin

podman-container:
	podman kill olivetin || true
	podman rm olivetin || true
	podman create --name olivetin -p 1337:1337 -v /etc/OliveTin/:/config:ro olivetin
	podman start olivetin

integration-tests-docker-image:
	docker rm -f olivetin && docker rmi -f olivetin
	docker build -t olivetin:latest .
	docker create --name olivetin -p 1337:1337 -v `pwd`/integration-tests/configs/:/config/ olivetin

devrun: compile
	killall OliveTin || true
	./OliveTin &

devcontainer: compile podman-image podman-container

webui-dist:
	$(MAKE) -wC frontend dist
	mv frontend/dist webui

clean:
	$(call delete-files,dist)
	$(call delete-files,OliveTin)
	$(call delete-files,OliveTin.armhf)
	$(call delete-files,OliveTin.exe)
	$(call delete-files,reports)
	$(call delete-files,gen)

config-tool:
	cd service && go run cmd/config-tool/main.go

.PHONY: proto service

.PHONY: linux
linux:
	-@rm -rf dist webui
	$(MAKE) webui-dist
	mkdir -p dist
	cd service && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ../dist/OliveTin -ldflags="-s -w -X main.version=$(shell git describe --tags --always) -X main.commit=$(shell git rev-parse --short HEAD) -X main.date=$(shell date -u +%Y-%m-%dT%H:%M:%SZ)"

.PHONY: alex-server
alex-server:
	@bash alex-server.sh
