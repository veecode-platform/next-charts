# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Helm chart repository for **VeeCode DevPortal**, a Backstage-based Internal Developer Platform (IDP). The main chart (`veecode-devportal-chart/`) wraps the upstream Backstage Helm chart (v2.5.3) and adds VeeCode-specific features: dynamic plugins, custom theming, RBAC cluster roles, and preconfigured plugin bundles.

Published as a Helm repo at `https://veecode-platform.github.io/next-charts`.

## Common Commands

```bash
# Update Helm dependencies
make deps

# Package chart and generate index (full build)
make all

# Release: fetch latest Docker tag, bump versions, package, and index
make release

# Release with a specific tag
./update_version.sh 1.0.18 && make index

# Clean generated artifacts
make clean

# Generate chart documentation from README.md.gotmpl
helm-docs

# Local development cluster
vkdr infra up
vkdr nginx install --default-ic

# Deploy locally
helm upgrade --install veecode-devportal ./veecode-devportal-chart -f examples/vkdr-minimal.yaml

# Dump running app-config for debugging
POD=$(kubectl get pods | grep "^veecode-devportal-" | awk '{print $1}')
kubectl exec -it $POD -- cat /opt/app-root/src/app-config.yaml | yq
```

## Architecture

- **`veecode-devportal-chart/`** — Main Helm chart (Chart API v2)
  - `Chart.yaml` — Version tracking: `version` = chart version, `appVersion` = Docker image tag
  - `values.yaml` — All configuration: global settings, dynamic plugins list with integrity hashes, upstream Backstage passthrough config, security contexts, probes
  - `templates/dynamic_plugins_configmap.yaml` — Generates ConfigMap from `global.dynamic.plugins`
  - `templates/clusterroles.yaml` — RBAC for the Kubernetes plugin
  - `templates/_helpers.tpl` — Shared template helpers (hostname, protocol, port, image)
- **`docs/`** — Published Helm repo (index.yaml + packaged .tgz releases)
- **`examples/`** — Example values files for local dev (vkdr-minimal, branding)

### Key Dependencies (in Chart.yaml)

| Alias | Chart | Purpose |
|-------|-------|---------|
| `upstream` | backstage v2.5.3 | Core Backstage Helm chart |
| `common` | bitnami/common ~2.x | Shared template utilities |

## Release Process

1. `update_version.sh` fetches the latest `veecode/devportal` tag from Docker Hub (or accepts a manual tag argument)
2. Updates `values.yaml` image tag and `Chart.yaml` appVersion
3. Auto-increments `Chart.yaml` patch version
4. `make index` runs `helm dependency update`, `helm package`, and `helm repo index`
5. Commit and push to `main` — `docs/` is served via GitHub Pages

## Values Structure

All configuration lives in `values.yaml`. Key sections:

- `global.host`, `global.protocol`, `global.port` — Base URL config
- `global.theme` — Custom UI theme (colors, logo, company name)
- `global.dynamic.plugins[]` — Dynamic plugin list with `package`, `integrity`, `disabled` fields
- `upstream.*` — Passthrough to the Backstage subchart (backstage image, env, volumes, probes, etc.)
