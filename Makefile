generate: generate-helm-docs generate-kustomization

generate-helm-docs:
	make -C charts/app-template

generate-kustomization:
	# TODO: prevent khelm from deleting non-yaml files in order to be able to regenerate a kustomization within a kpt package.
	# Maybe don't delete any resources at all?
	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
		mgoltzsche/khelm:2.2.1 \
		template app charts/app-template/ -o kustomizations/webapp/ --output-replace

kpt-pkg-update:
	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
		gcr.io/kpt-dev/kpt:v1.0.0-beta.21 pkg update kustomizations/webapp
