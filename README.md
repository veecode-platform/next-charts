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
POD=$(kubectl get pods | grep "^veecode-devportal-upstream" | awk '{print $1}')
kubectl exec -it $POD -- cat /app/app-config-from-configmap.yaml
```

## Generate chart README.md

```bash
helm-docs
```

## Release

Increment version in Chart.yaml and package + index a new release:

```bash
make release
```
