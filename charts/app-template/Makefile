IMAGE=mgoltzsche/kubemate-webapp-manifest-generator

all: image

generate: HELM_DOCS_TEMPLATE=README.md.gotmpl
generate:
	docker run --rm --volume "$(CURDIR):/helm-docs" -u `id -u` \
		jnorwood/helm-docs:v1.11.0 -l debug -t $(HELM_DOCS_TEMPLATE)

image: generate
	docker build --force-rm -t $(IMAGE) .
