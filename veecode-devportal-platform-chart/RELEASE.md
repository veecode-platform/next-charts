# Releasing `veecode-devportal-platform`

Maintainer notes for cutting and publishing a chart release. (User-facing install
instructions are in [`README.md`](./README.md).)

## Image ↔ chart version sync (manual)

The image (`devportal-platform`) and this chart live in separate repos and the coupling
is one-way: the **image does not reference the chart**; the **chart pins the image**. There
is no automation closing that loop, so it is a manual step — same as the V1
`veecode-devportal` chart.

When the DevPortal V2 image publishes a new tag, in the **same change** bump:

| Field | File | Set to |
| ----- | ---- | ------ |
| `image.tag` | `values.yaml` | the new image tag (e.g. `2.0.1`) |
| `appVersion` | `Chart.yaml` | the **same** image tag (quoted) |
| `version` | `Chart.yaml` | the chart's own SemVer — bump for **any** chart change (chart-only fixes bump only this) |

`appVersion` and `image.tag` must always match. `version` is the chart's independent SemVer.

> The V1 repo automates the bump with `update_version.sh` (hardcoded to the V1 chart dir
> and `veecode/devportal`). It does **not** cover this chart — bump the three fields above
> by hand, or extend that script for `veecode-devportal-platform-chart` / `veecode/devportal`.

## Publishing to the Helm repo

This repo has **no CI publish workflow** — publishing to the gh-pages Helm index
(`https://veecode-platform.github.io/next-charts`, scraped by ArtifactHub) is the
repo's existing **manual maintainer step**. Follow whatever the repo already does to
publish `veecode-devportal` (package the chart + regenerate `index.yaml` + push to the
`gh-pages` branch). Do not invent a new path here — mirror the established one.

After publishing, confirm the release is consumable:

```sh
helm repo add next-charts https://veecode-platform.github.io/next-charts
helm repo update next-charts
helm search repo veecode-devportal-platform   # must list the new chart version
```

## Consumers (do not point them at an unpublished chart)

Two downstreams consume the **published** chart — point them at it only **after** the
publish step above succeeds:

- **VKDR** — `vkdr devportal-platform install` (installs `veecode-devportal-platform`
  from the next-charts Helm repo).
- **Install docs** — the V2 Helm/k8s install path (`helm repo add next-charts …` →
  `helm install … veecode-devportal-platform`).

The raw `examples/deploy/k8s.yaml` in the image repo stays as the minimal, no-Helm
fallback and does not depend on this chart being published.
