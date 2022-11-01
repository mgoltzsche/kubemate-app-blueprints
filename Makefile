#generate: generate-helm-docs generate-kustomization

#generate-helm-docs:
#	make -C charts/app-template

#generate-kustomization:
#	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
#		mgoltzsche/khelm:2.2.1 \
#		template app charts/app-template/ --set kptSetter=false --set image.repository=appimage --set image.tag=tag -o kustomizations/webapp/config/base/ --output-replace

CHARTS=$(shell ls ./charts)
CHARTS_TARGETS=$(addprefix charts-,$(CHARTS))
PACKAGES=$(shell ls ./kustomizations)
RENDER_TARGETS=$(addprefix render-,$(PACKAGES))

all: render

.PHONY: charts
charts: $(CHARTS_TARGETS) ## Build all chart kpt functions.

$(CHARTS_TARGETS): charts-%:
	make image -C ./charts/$*

render: $(RENDER_TARGETS) ## Render all kpt functions / generate manifests.

$(RENDER_TARGETS): render-%:
	make kpt-fn-render -C ./kustomizations/$*

kpt-pkg-update:
	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
		gcr.io/kpt-dev/kpt:v1.0.0-beta.21 pkg update kustomizations/webapp

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

