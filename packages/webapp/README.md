# webapp

## Description
kubemate webapp blueprint.

## Usage

### Fetch the package
`kpt pkg get https://github.com/mgoltzsche/kubemate-app-blueprints.git/packages/webapp[@VERSION] myapp`

or with `docker`:
```
docker run --rm -u `id -u` -e HOME=/tmp -v `pwd`:/data -w /data gcr.io/kpt-dev/kpt:v1.0.0-beta.21 pkg get https://github.com/mgoltzsche/kubemate-app-blueprints.git/packages/webapp myapp
```

Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree myapp`

Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init myapp
kpt live apply myapp --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
