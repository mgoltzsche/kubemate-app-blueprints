# app-template

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square)

Simple kubemate app template

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| env | object | `{}` | Environment variables for the application. An object with env var names as keys. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.repository | string | `"nginxdemos/nginx-hello"` | The registry and image name for the application. |
| image.tag | string | `"0.2"` | Docker image tag. |
| ingress.annotations | object | `{}` |  |
| ingress.class | string | `"kubemate"` | The ingress class name. The default exposes the app only when deployed to kubemate. When you want the app to be exposed without authentication within any Kubernetes cluster, set this value to an empty string. |
| ingress.enabled | bool | `true` | Expose the application outside the cluster via HTTP. |
| ingress.host | string | `""` | The host name under which the application should be published. Defaults to the kubemate node host. |
| ingress.paths | list | `[]` | The path prefixes under which the application should be exposed. Defaults to `/<appname>/`. |
| ingress.tlsSecret | string | `""` |  |
| kptSetter | bool | `false` | Enables kpt setter generation. To use the setters afterwards, see https://catalog.kpt.dev/apply-setters/v0.2/ |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.path | string | `"/healthz"` | Path to the liveness probe / health check endpoint. |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `1` |  |
| nav.iconURL | string | `""` | Optional navigation entry icon URL. |
| nav.title | string | `""` | The navigation entry title within kubemate UI. Defaults to release name. |
| readinessProbe.path | string | `"/healthz"` | Path to the readiness probe endpoint. |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| replicas | int | `1` | Number of Pods that should be scheduled to run this app. |
| resources.limits | object | `{"cpu":"200m","memory":"64Mi"}` | Hard resource constraints for the application. When it attempts to allocate more resources it gets killed (and restarted eventually). |
| resources.requests | object | `{"cpu":"100m","memory":"32Mi"}` | Resource constraints for the application. The amount of resources the process requires usually. This information is used by the Pod scheduler to distribute workloads across all available nodes/machines and to avoid overloading a single node. The application may still allocate more resources. |
| service.annotations | object | `{}` |  |
| service.port | int | `8080` | Internal container port. |
| service.type | string | `"ClusterIP"` | Service type, e.g. `ClusterIP`, `NodePort`, `LoadBalancer`. |
| skaffold | bool | `false` | Generates a skaffold.yaml file when enabled. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
