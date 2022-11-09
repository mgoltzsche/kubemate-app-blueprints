IMAGE_TAG ?= dev
IMAGE_TAGS ?= $(IMAGE_TAG)

#KPT_IMAGE=gcr.io/kpt-dev/kpt:v1.0.0-beta.21
KPT_IMAGE ?= mgoltzsche/kpt-docker:1.0.0-beta.21
KPT_RESOURCEGROUP := config/kpt/resourcegroup.yaml
SKAFFOLD_IMAGE ?= gcr.io/k8s-skaffold/skaffold/v2:v2.0.0-beta1
SKAFFOLD_OPTS ?=
SKAFFOLD_YAML ?= skaffold.yaml
KUBECONFIG ?= $$HOME/.kube/config
YQ_IMAGE := mikefarah/yq:4.29.2

DOCKER ?= docker
PLATFORM ?= linux/amd64
EXPORT_OPTS ?= --load
BUILDX_BUILDER ?= kubemate-app-builder
BUILDX_OPTS = --platform=$(PLATFORM) $(EXPORT_OPTS) --builder=$(BUILDX_BUILDER)
IMAGE_MAPPING_FILE = image.yaml
IMAGE_MAPPING_EXPR := '.images[] | . as $$img | "-f "+(.dockerfile // "Dockerfile") \
	+" "+(.context // ".") \
	+" --target="+(.target // "") \
	+" "+([env(TAGS) | split(",").[] | "-t "+($$img.name)+":"+.] | join(" "))'


all: image

##@ Build

.PHONY: image
image: create-builder ## Build the container image(s).
	@cat $(IMAGE_MAPPING_FILE) | $(DOCKER) run -i --rm -e TAGS="$(IMAGE_TAGS)" $(YQ_IMAGE) eval -e $(IMAGE_MAPPING_EXPR) | while IFS= read -r CTX; do \
		(set -x; $(DOCKER) buildx build $$CTX $(BUILDX_OPTS) --force-rm); \
	done

.PHONY: image-multiarch
image-multiarch: PLATFORM = linux/arm64/v8,linux/amd64
image-multiarch: EXPORT_OPTS = --output=type=image
image-multiarch: image ## Build multi-arch container image(s).

.PHONY: binfmt-config
binfmt-config: ## Enable multi-arch support on the host.
	$(DOCKER) run --rm --privileged multiarch/qemu-user-static:7.0.0-7 --reset -p yes

.PHONY: create-builder
create-builder: ## Create a new docker buildx builder.
	$(DOCKER) buildx inspect $(BUILDX_BUILDER) >/dev/null 2<&1 || $(DOCKER) buildx create --name=$(BUILDX_BUILDER) >/dev/null

.PHONY: delete-builder
delete-builder: ## Delete the docker buildx builder.
	$(DOCKER) buildx rm $(BUILDX_BUILDER)

.PHONY: manifest
manifest:
	kubectl kustomize ./deploy/kpt

##@ Deploy

#deploy: kpt-live-apply ## Deploy the application.
#undeploy: kpt-live-destroy ## Undeploy the application.
#kpt-live-apply kpt-live-destroy: kpt-live-%: $(KPT_RESOURCEGROUP)
#	kubectl kustomize ./config/kpt | docker run -i --rm --network=host \
#		--mount "type=bind,src=$(KUBECONFIG),dst=/tmp/.kube/config,ro" \
#		-e HOME=/tmp -u "`id -u`:`id -g`" \
#		$(KPT_IMAGE) live $* -

#$(KPT_RESOURCEGROUP):
#	docker run --rm -u "`id -u`:`id -g`" -v `pwd`:/data -w /data \
#		$(KPT_IMAGE) live init config/kpt

##@ Development

render: kpt-fn-render ## Run kpt render pipeline, applying setters.yaml.
kpt-fn-render: kpt-fn-%:
	docker run -i --rm -u "`id -u`:`id -g`" --group-add 998 \
		-v "/var/run/docker.sock:/var/run/docker.sock" \
		-v "`pwd`:/data" \
		$(KPT_IMAGE) fn $* /data --truncate-output=false

debug: SKAFFOLD_OPTS = --auto-build
debug: skaffold-debug ## Deploy the application in debug mode, using skaffold.
delete: skaffold-delete ## Undeploy the skaffold/debug application.
skaffold-run skaffold-stop skaffold-build skaffold-delete skaffold-debug skaffold-help: skaffold-%:
	docker run --rm -v "`pwd`:/data" -w /data \
		-v "/var/run/docker.sock:/var/run/docker.sock" \
		--mount "type=bind,src=$(KUBECONFIG),dst=/tmp/.kube/config,ro" \
		-e KUBECONFIG=/tmp/.kube/config \
		--network=host \
		$(SKAFFOLD_IMAGE) skaffold $* $(SKAFFOLD_OPTS)

update: ## Apply the latest blueprint updates to this codebase.
	mkdir -p $$HOME/.kpt
	docker run --rm -u "`id -u`:`id -g`" -v "$$HOME/.kpt:/.kpt" -v `pwd`:/data -w /data \
		$(KPT_IMAGE) pkg update --strategy=resource-merge .
	make kpt-fn-render

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Release

.PHONY: release
release: PLATFORM = linux/arm64/v8,linux/amd64
release: IMAGE_TAGS = $(IMAGE_TAG) latest
release: EXPORT_OPTS = --push
release: image ## Build and push the multi-arch image(s).
