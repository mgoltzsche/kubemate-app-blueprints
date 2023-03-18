PACKAGES=$(shell ls ./packages)
RENDER_TARGETS=$(addprefix render-,$(PACKAGES))

all: render

render: $(RENDER_TARGETS) ## Render all kpt functions / generate manifests.

$(RENDER_TARGETS): render-%:
	make kpt-fn-render -C ./packages/$*

kpt-pkg-update:
	docker run --rm -u `id -u` -v `pwd`:/data -w /data -e HOME=/tmp/home \
		gcr.io/kpt-dev/kpt:v1.0.0-beta.25 pkg update packages/webapp

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
