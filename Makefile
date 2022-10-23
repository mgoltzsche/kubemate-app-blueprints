generate: generate-helm-docs generate-kustomization

generate-helm-docs:
	make -C charts/app-template

generate-kustomization:
	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
		mgoltzsche/khelm:2.2.1 \
		template app charts/app-template/ --set kptSetter=true -o kustomizations/webapp/config/base/ --output-replace

kpt-pkg-update:
	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
		gcr.io/kpt-dev/kpt:v1.0.0-beta.21 pkg update kustomizations/webapp
