# webapp blueprint

## Description
kubemate web application blueprint.

## Usage
Create a new application by fetching, configuring and rendering this [kpt](https://kpt.dev/) package.

### Prerequisites

* make
* docker 1.20+

### Fetch the package
`kpt pkg get https://github.com/mgoltzsche/kubemate-app-blueprints.git/packages/webapp[@VERSION] myapp`

or with `docker`:
```
docker run --rm -u `id -u` -e HOME=/tmp -v `pwd`:/data -w /data gcr.io/kpt-dev/kpt:v1.0.0-beta.21 pkg get https://github.com/mgoltzsche/kubemate-app-blueprints.git/packages/webapp myapp
```

Details: https://kpt.dev/reference/cli/pkg/get/

### Customize the package
Within the fetch package's directory, edit [`setters.yamll`](./setters.yaml) to meet your needs.
To replace the corresponding values within the manifests and skaffold.yaml, call `make render` or rather `kpt fn render`.

Details: https://kpt.dev/reference/cli/fn/render/

Also see the [Variant Constructor Pattern](https://kpt.dev/guides/variant-constructor-pattern).

### Update the package
To apply the latest blueprint changes to the codebase, call `make update` or rather `kpg pkg update && kpt fn render` (the kpt render pipeline applies the configuration within [`setters.yamll`](./setters.yaml) to the manifests and `skaffold.yaml`).
Before committing the changes, review them carefully and make manual changes if necessary.

Details: https://kpt.dev/reference/cli/pkg/update/

### Build the application
To build the application container image, call:
```sh
make image
```

### Deploy the application
To deploy the application (using [skaffold](https://skaffold.dev)), call:
```sh
make deploy
```
To deploy the application in debug mode (debug ports forwarded), stream its logs and redeploy on source code changes automatically, call:
```sh
make debug
```

To undeploy the application, call:
```sh
make undeploy
```
