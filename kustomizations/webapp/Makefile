APP=app
KPT_IMAGE=gcr.io/kpt-dev/kpt:v1.0.0-beta.21
KPT_RESOURCEGROUP=config/kpt/resourcegroup.yaml
KUBECONFIG?=$$HOME/.kube/config

all: build

build:
	docker build --force-rm -t $(APP) .

manifest:
	kubectl kustomize ./config/kpt

deploy: kpt-live-apply
undeploy: kpt-live-destroy
kpt-live-apply kpt-live-destroy: kpt-live-%: $(KPT_RESOURCEGROUP)
	kubectl kustomize ./config/kpt | docker run -i --rm --network=host \
		--mount "type=bind,src=$(KUBECONFIG),dst=/tmp/.kube/config,ro" \
		-e HOME=/tmp -u "`id -u`:`id -g`" \
		$(KPT_IMAGE) live $* -

update:
	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
		gcr.io/kpt-dev/kpt:v1.0.0-beta.21 pkg update kustomizations/webapp

$(KPT_RESOURCEGROUP):
	docker run --rm -u "`id -u`:`id -g`" -v `pwd`:/data -w /data \
		$(KPT_IMAGE) live init config/kpt
