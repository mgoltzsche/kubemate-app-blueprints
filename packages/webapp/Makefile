IMAGE?=$(shell grep ' image: ' skaffold.yaml | sed -E 's/^\s+- image: //; s/\#.*//')
#KPT_IMAGE=gcr.io/kpt-dev/kpt:v1.0.0-beta.21
KPT_IMAGE=mgoltzsche/kpt-docker:1.0.0-beta.21
KPT_RESOURCEGROUP=config/kpt/resourcegroup.yaml
SKAFFOLD_IMAGE=gcr.io/k8s-skaffold/skaffold/v2:v2.0.0-beta1
SKAFFOLD_OPTS=
SKAFFOLD_YAML=skaffold.yaml
KUBECONFIG?=$$HOME/.kube/config

all: build

build:
	docker build --force-rm -t $(IMAGE) .

manifest:
	kubectl kustomize ./config/kpt

deploy: kpt-live-apply
undeploy: kpt-live-destroy
kpt-live-apply kpt-live-destroy: kpt-live-%: $(KPT_RESOURCEGROUP)
	kubectl kustomize ./config/kpt | docker run -i --rm --network=host \
		--mount "type=bind,src=$(KUBECONFIG),dst=/tmp/.kube/config,ro" \
		-e HOME=/tmp -u "`id -u`:`id -g`" \
		$(KPT_IMAGE) live $* -

render: kpt-fn-render
kpt-fn-render: kpt-fn-%:
	docker run -i --rm -u "`id -u`:`id -g`" --group-add 998 \
		-v "/var/run/docker.sock:/var/run/docker.sock" \
		-v "`pwd`:/data" \
		$(KPT_IMAGE) fn $* /data --truncate-output=false

skaffold-run skaffold-stop skaffold-build skaffold-delete skaffold-debug skaffold-help: skaffold-%: $(SKAFFOLD_YAML)
	docker run --rm -v "`pwd`:/data" -w /data \
		-v "/var/run/docker.sock:/var/run/docker.sock" \
		--mount "type=bind,src=$(KUBECONFIG),dst=/tmp/.kube/config,ro" \
		-e KUBECONFIG=/tmp/.kube/config \
		--network=host \
		$(SKAFFOLD_IMAGE) skaffold $* $(SKAFFOLD_OPTS)

update:
	mkdir -p $$HOME/.kpt
	docker run --rm -u "`id -u`:`id -g`" -v "$$HOME/.kpt:/.kpt" -v `pwd`:/data -w /data \
		$(KPT_IMAGE) pkg update .
	make kpt-fn-render

$(KPT_RESOURCEGROUP):
	docker run --rm -u "`id -u`:`id -g`" -v `pwd`:/data -w /data \
		$(KPT_IMAGE) live init config/kpt

$(SKAFFOLD_YAML):
	docker run --rm -v "`pwd`:/data" -w /data --entrypoint sh \
		$(SKAFFOLD_IMAGE) -c "set -eux; \
			skaffold init --force; \
			chown `id -u`:`id -g` skaffold.yaml; \
		"
