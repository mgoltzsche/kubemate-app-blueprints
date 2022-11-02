FROM mgoltzsche/khelm:latest
COPY . /chart
ENV KHELM_BUILTIN_CHART=/chart \
	KHELM_KIND=Webapp \
	KHELM_APIVERSION=blueprints.kubemate.mgoltzsche.github.com/v1alpha1 \
	KHELM_OUTPUT_PATH=deploy/generated/
# populate cache
RUN khelm template $KHELM_BUILTIN_CHART >/dev/null && chmod +rx /helm/cache
