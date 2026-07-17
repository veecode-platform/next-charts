# veecode-devportal-platform

Helm chart for **VeeCode DevPortal V2** (the `devportal-platform` image line). Standalone chart — it does **not** wrap the upstream Backstage chart. Built from the V2 runtime contract (`entrypoint.sh`): presets-driven enablement, persistent SQLite by default, and plugin install owned by the image entrypoint (no install initContainer).

> This is a different chart from the V1 `veecode-devportal` (which deploys the 1.x distro). Use this one for `docker.io/veecode/devportal:2.0.0+`.

## Quick start

**Installing DevPortal?** Use the published chart from this repo's Helm repo — not a local path:

```sh
helm repo add next-charts https://veecode-platform.github.io/next-charts
helm repo update next-charts

helm install devportal next-charts/veecode-devportal-platform \
  --set 'presets={recommended,github,github-auth}' \
  --set existingSecret=my-devportal-creds        # Secret holding the preset's required vars
```

Full walkthrough (Secret creation, PostgreSQL, ingress): [Deploy to Kubernetes](https://docs.platform.vee.codes/devportal/installation-guide/production-setup/setup).

**Working on this chart's source?** Install straight from the local checkout instead:

```sh
helm install dp ./veecode-devportal-platform-chart \
  --set 'presets={recommended,github,github-auth}' \
  --set existingSecret=my-devportal-creds        # Secret holding the preset's required vars
```

Then:

```sh
kubectl rollout status deploy/dp-veecode-devportal-platform --timeout=10m
kubectl port-forward svc/dp-veecode-devportal-platform 7007:7007
curl -sf localhost:7007/healthcheck && echo OK
```

## How enablement works

`presets` is joined into the `VEECODE_PRESETS` env var. Each preset can declare required variables; if any are missing the **boot fails fast with exit 78**. Selecting two identity presets (the `exclusive_group: identity` set) also fails with exit 78.

Provide the required variables through **one** of:

- `existingSecret: <name>` — a Secret you manage (recommended for production), consumed via `envFrom`.
- `credentials: { KEY: value, ... }` — the chart renders a Secret (dev convenience; plaintext in your values).

### Per-preset required variables

`(S)` = secret. Route all of a preset's variables through the Secret for simplicity. `[optional]` in brackets.

**Identity presets — pick AT MOST ONE (`exclusive_group: identity`):**

| Preset        | Required variables |
| ------------- | ------------------ |
| `github-auth` | `GITHUB_PAT`(S), `GITHUB_ORG`, `GITHUB_AUTH_CLIENT_ID`, `GITHUB_AUTH_CLIENT_SECRET`(S) |
| `azure-auth`  | `AZURE_AUTH_TENANT_ID`, `AZURE_AUTH_CLIENT_ID`, `AZURE_AUTH_CLIENT_SECRET`(S) |
| `gitlab`      | `GITLAB_HOST`, `GITLAB_AUTH_CLIENT_ID`, `GITLAB_AUTH_CLIENT_SECRET`(S), `GITLAB_TOKEN`(S), `GITLAB_GROUP`, `[GITLAB_GROUP_PATTERN]` |
| `keycloak`    | `KEYCLOAK_BASE_URL`, `KEYCLOAK_REALM`, `KEYCLOAK_CLIENT_ID`, `KEYCLOAK_CLIENT_SECRET`(S), `AUTH_SESSION_SECRET`(S) |
| `ldap`        | `LDAP_URL`, `LDAP_DN`, `LDAP_SECRET`(S), `LDAP_USERS_BASE_DN`, `LDAP_GROUPS_BASE_DN`, `[LDAP_USERS_FILTER]`, `[LDAP_GROUPS_FILTER]` |

**Integration presets (composable):**

| Preset       | Required variables |
| ------------ | ------------------ |
| `github`     | `GITHUB_PAT`(S), `GITHUB_ORG` |
| `azure`      | `AZURE_DEVOPS_TOKEN`(S), `AZURE_DEVOPS_HOST`, `AZURE_DEVOPS_ORG`, `AZURE_DEVOPS_PROJECT` |
| `jenkins`    | `JENKINS_URL`, `JENKINS_USERNAME`, `JENKINS_TOKEN`(S) |
| `kubernetes` | `K8S_CLUSTER_NAME`, `K8S_CLUSTER_URL`, `K8S_CLUSTER_TOKEN`(S) — also set `rbac.clusterRoles.create=true` |
| `sonarqube`  | `SONARQUBE_BASE_URL`, `SONARQUBE_API_KEY`(S) |
| `mcp-chat`   | `MCP_CHAT_PROVIDER`, `MCP_CHAT_API_KEY`(S), `MCP_CHAT_MODEL` |

**No required variables:** `recommended`, `veecode-theme`, `mcp`, `ldap-ad`.

## Storage

Two PersistentVolumeClaims, both **required** for production:

- `/app/data` (`persistence.data`) — SQLite DBs + marketplace state. Must be a directory PVC. Losing it wipes catalog/marketplace state on restart.
- `/app/dynamic-plugins-root` (`persistence.plugins`) — OCI plugin bundle cache. A **seed initContainer** copies the image's baked plugins into this PVC on first boot (a bare PVC would otherwise mask the 7 pre-installed plugins, including the homepage, global header, and marketplace catalog). On restart the copy no-clobbers, so the download cache is reused.

> **On image upgrade:** the seed uses `cp -rn` (no-clobber), matching the docker-compose named-volume behaviour, so it will not overwrite pre-installed plugin bytes already in the PVC. After bumping `image.tag` to a build with updated pre-installed plugins, delete the plugins PVC (or point `persistence.plugins.existingClaim` at a fresh one) so the new versions are seeded — the OCI-downloaded plugins re-resolve automatically.

## Database

Default is **persistent SQLite** on the `/app/data` PVC with `replicaCount: 1`. For scale/HA, set:

```yaml
database:
  external:
    enabled: true   # injects a backend.database (client: pg) block into app-config.local.yaml
replicaCount: 2
```

and provide `PG_HOST`, `PG_PORT`, `PG_USER`, `PG_PASSWORD`, `PG_DATABASE` in the credentials Secret. The chart does **not** bundle a PostgreSQL subchart — point at an external/managed instance.

## Key values

| Key | Default | Notes |
| --- | --- | --- |
| `image.repository` / `image.tag` | `docker.io/veecode/devportal` / `2.0.0` | Pinned; never `:latest`. |
| `presets` | `[recommended]` | → `VEECODE_PRESETS`. |
| `existingSecret` / `credentials` | `""` / `{}` | Preset credentials. |
| `persistence.data` / `persistence.plugins` | enabled, 1Gi / 2Gi | The two PVCs. |
| `pluginRegistry` / `catalogIndexImage` | `""` | Mirror / air-gap overrides. |
| `theme.*` | `""` | `THEME_*` env (or use the `veecode-theme` preset). |
| `appConfig` | `{}` | Minimal operator `app-config.local.yaml` overrides. |
| `ingress.enabled` | `false` | Serves at `/` on port 7007 (no sub-path). |
| `rbac.clusterRoles.create` | `false` | Enable for the `kubernetes` preset. |
| `resources` | 250m/512Mi → 1/2Gi | Validate first-boot headroom for your cluster. |

See [`values.yaml`](./values.yaml) for the complete surface.
