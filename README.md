# argo-sidecar-plugin-creds-repro

**NOTE:** This repo was created to reproduce the conditions for [argoproj/argo-cd](https://github.com/argoproj/argo-cd) [issue #8820](https://github.com/argoproj/argo-cd/issues/8820), will only be modified in the context of such issue, and won't be further maintained once that issue has been fixed, merged and released.

## Prerequisites

* [k3d](https://github.com/k3d-io/k3d/#get) 5.4.1
* [Helm](https://github.com/helm/helm#install) >= 3.0.0
* [helmfile](https://github.com/roboll/helmfile#installation) 0.139.7
* A GitHub personal access token

## How to run

**NOTE:** Since the point of this reproduction repo is to test git credentials on private dependencies for Tanka, you'll need to create another repo to hold the `./jsonnet` directory, make it private, and point `jsonnetfile.json` there, in order to create the right conditions. This was originally tested by making this repo private, but it has been made public so it can be easily shared.

* Run `export GITHUB_TOKEN=<your-github-access-token>`
* Run `export GITHUB_USERNAME=<your-github-username>`
* Run `export KUBECONFIG=~/.k3d/k3s-default-config`
* Run `make start`
* This should bring up a local k3d cluster with Argo v2.2.8 running (and exposed at http://localhost:8080, with admin/admin123), that you can immediately interact with.

## Scenarios

### Successful deployment (v2.2)

* Run `kubectl apply -f manifests/tanka-application.yaml`
* A new application tile should come up on the UI, and after a minute or two it should be synced and healthy, and you should see a `grafana` and a `prometheus` deployment in the `default` namespace.
* The credentials are being provided by a `git-ask-pass.sh` file mounted on the Tanka plugin sidecar, and reading off environment variables injected into the container.

### Failed sync after upgrade (v2.3)

* Change the value of `global.image.tag` on `helmfile.d/values/argo-cd.yaml` to point to any `=< 2.3` version, e.g. `v2.3.3`.
* Run `make apply`
* Wait for the release to finish and the Argo control plane with the new version is stable.
* Log in to the UI at http://localhost:8080 with credentials admin/admin123
* Click on the `tanka-application` tile.
* Click on the `Refresh` dropdown and select `Hard Refresh`.
* Notice that under `APP CONDITIONS` it will now show `1 Error`.
* If you expand that error, you'll see a `ComparisonError`, complaining about `jb install` (the Tanka plugin `init` command) not being able to find the credentials to pull its dependencies.