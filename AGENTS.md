# Agent Guidelines

This repository is the public VeeCode Helm repository,
`https://veecode-platform.github.io/next-charts`. GitHub Pages serves `docs/`
from `main`: `docs/index.yaml` plus the packaged `.tgz` files.

## The three chart lines

| Chart in the index | Portal line | Source | How a version gets here |
|---|---|---|---|
| `devportal` | 3.x | `veecode-platform/devportal-chart` | `ingest-devportal-chart.yml`, dispatched by hand with the version, downloads the GitHub Release package, checks its checksum, name and version, and commits the `.tgz` |
| `veecode-devportal-platform` | 2.x | `veecode-devportal-platform-chart/` here | `sync-platform-version.yml` runs daily, on dispatch or on `platform-image-released`, requires `appVersion` to equal the image tag, and bumps the chart; see its `RELEASE.md` |
| `veecode-devportal` | 1.x | `veecode-devportal-chart/` here | `make release` with `update_version.sh`; see [veecode-devportal-chart/AGENTS.md](veecode-devportal-chart/AGENTS.md) |

`release-charts.yml` then packages every chart version missing from `docs/` and
merges `docs/index.yaml`. The `devportal` package is never rebuilt here: this
repository publishes the exact package `devportal-chart` released.

## Verify a change

```bash
helm dependency build veecode-devportal-platform-chart
helm lint veecode-devportal-platform-chart
for f in veecode-devportal-platform-chart/ci/*.yaml; do helm template t veecode-devportal-platform-chart -f "$f" > /dev/null; done
```

The 1.x chart needs the `backstage` and `bitnami` Helm repositories added before
`helm dependency build`.

## Rules

- Never edit a published `.tgz` or its `docs/index.yaml` entry by hand; a
  released version is immutable.
- `CLAUDE.md` delegates here. The 1.x chart keeps its own commands in
  [veecode-devportal-chart/AGENTS.md](veecode-devportal-chart/AGENTS.md).
