# Releasing `veecode-devportal-platform`

Maintainer notes for cutting and publishing a chart release. (User-facing install
instructions are in [`README.md`](./README.md).)

## Image ↔ chart version sync (automated)

The image (`devportal-platform`) and this chart live in separate repos and the coupling
is one-way: the **image does not reference the chart**; the **chart pins the image**.

That loop is now closed automatically by
[`.github/workflows/sync-platform-version.yml`](../.github/workflows/sync-platform-version.yml)
(Design A). It runs daily (cron `0 6 * * *`), on `workflow_dispatch`, and on a
`repository_dispatch` of type `platform-image-released` (a future fast-path; the
platform side is not wired up yet). On each run it:

1. resolves the target image version from the latest **non-prerelease** GitHub Release of
   `veecode-platform/devportal-platform` (`releases/latest`, which excludes `-rc`/`-alpha`/
   `-beta`/`-preview`), or from `client_payload.version` on the dispatch fast-path;
2. **hard-rejects** anything that is not a stable `x.y.z`;
3. is **idempotent** — if `Chart.yaml` `appVersion` already equals the target, it exits
   with no commit;
4. otherwise edits the three fields below and commits to `main` as `github-actions[bot]`.

| Field | File | Set to |
| ----- | ---- | ------ |
| `image.tag` | `values.yaml` | the new image tag (e.g. `2.1.0`) |
| `appVersion` | `Chart.yaml` | the **same** image tag (quoted) |
| `version` | `Chart.yaml` | bumped per the rule below |

`appVersion` and `image.tag` must always match (the workflow asserts this). `version` is
the chart's independent SemVer and the chart deliberately stays in the `0.x` range.

**Bump rule** (image change → chart `version` bump):

| Image change | Chart `version` bump | Notes |
| ------------ | -------------------- | ----- |
| patch (`2.1.0`→`2.1.1`) | patch (`0.2.0`→`0.2.1`) | |
| minor (`2.1.0`→`2.2.0`) | minor (`0.2.0`→`0.3.0`) | |
| major (`2.x`→`3.0.0`)   | minor (`0.2.0`→`0.3.0`) | also emits a `::warning::` — review templates; the chart is **not** auto-crossed to `1.0.0` |

> **Chart-only fixes** (a template fix, a values default change, etc., with no image
> change) are still a **manual** `version` patch by a maintainer — the reconciler only
> moves on an image-version change. Bump `version` by hand and push to `main`; the publish
> workflow below packages it.
>
> The V1 `veecode-devportal` chart remains on its own manual `update_version.sh` flow;
> `sync-platform-version.yml` covers **only** this V2 chart.

## Publishing to the Helm repo

Publishing is automated by [`.github/workflows/release-charts.yml`](../.github/workflows/release-charts.yml).
GitHub Pages serves the Helm repo (`https://veecode-platform.github.io/next-charts`,
scraped by ArtifactHub) straight from **`main/docs`** — there is **no `gh-pages`
branch**. `release-charts.yml` packages new chart versions and regenerates `docs/index.yaml`
on any push to `main` that touches a chart dir; it commits `publish: … [skip ci]`. A chart
version whose `.tgz` is already in `docs/` is skipped, so a non-version change (e.g. a
README edit) produces no release.

Two ways a release happens:

- **Image-version sync** — `sync-platform-version.yml` commits the version bump and then
  **explicitly dispatches** `release-charts.yml`. (The explicit dispatch is required: a
  push authored by the Actions `GITHUB_TOKEN` does **not** fire other workflows, so the
  bump commit alone would not publish. `workflow_dispatch` is one of the few events the
  `GITHUB_TOKEN` is allowed to trigger.)
- **Manual chart-only bump** — a maintainer pushing a `version` bump to `main` (authored
  by a real user / PAT) triggers `release-charts.yml` directly via the normal `push`
  event. You can also run it on demand from the Actions tab (`workflow_dispatch`).

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
