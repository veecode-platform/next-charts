# next-charts

Next generation VeeCode Helm Charts

## Development

Download chart dependencies:

```bash
cd veecode-devportal-chart
helm dependency update
```

Start local cluster:

```bash
vkdr infra up # port 8000
vkdr nginx install --default-ic
```

## Secrets

Use a PAT from GitHub to authenticate with GitHub (permissions: "repo:full, workflow"):

```bash
# idempotent command
kubectl create secret generic my-backstage-secrets \
  --from-literal=BACKEND_AUTH_SECRET_KEY=somethingrandom \
  --from-literal=GITHUB_TOKEN=${GITHUB_TOKEN} \
  --dry-run=client --save-config -o yaml | kubectl apply -f -
```

## Deployment

Deploy locally:

```bash
helm upgrade --install veecode-devportal ./veecode-devportal-chart \
    -f examples/vkdr-minimal.yaml
```

Dump generated app-config:

```bash
POD=$(kubectl get pods | grep "^veecode-devportal-" | awk '{print $1}')
kubectl exec -it $POD -- cat /opt/app-root/src/app-config.yaml | yq
```

## Generate chart README.md

Improve documentation in `veecode-devportal-chart/README.md.gotmpl` and run:

```bash
helm-docs
```

## Release

Increment version in Chart.yaml and package + index a new release:

```bash
make release
```

