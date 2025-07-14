# next-charts

Next generation VeeCode Helm Charts

## Secrets

```bash
# idempotent command
kubectl create secret generic my-backstage-secrets \
  --from-literal=BACKEND_AUTH_SECRET_KEY=${BACKEND_AUTH_SECRET_KEY} \
  --from-literal=GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID} \
  --from-literal=GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} \
  --from-literal=GITHUB_PRIVATE_KEY=${GITHUB_PRIVATE_KEY} \
  --from-literal=GITHUB_WEBHOOK_SECRET=${GITHUB_WEBHOOK_SECRET} \
  --from-literal=GITHUB_APP_ID=${GITHUB_APP_ID} \
  --from-literal=GITHUB_TOKEN=${GITHUB_TOKEN} \
  --from-literal=GA_ANALYTICS_ID=${GA_ANALYTICS_ID} \
  --dry-run=client --save-config -o yaml | kubectl apply -f -
```

## Development

Download chart dependencies:

```bash
cd veecode-devportal-chart
helm dependency update
```

Start local cluster:

```bash
vkdr infra start --http 80 --https 443
vkdr nginx install --default-ic
```

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
