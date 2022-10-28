all: render-webapp

render-webapp: render-%:
	make kpt-fn-render -C ./kustomizations/$*

update:
	docker run --rm -u `id -u` -v `pwd`:/data -w /data \
		gcr.io/kpt-dev/kpt:v1.0.0-beta.21 pkg update kustomizations/webapp
