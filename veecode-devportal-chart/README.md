# veecode-devportal

Parent Helm Chart for VeeCode DevPortal, wrapping the official Backstage chart

![Version: 1.0.2](https://img.shields.io/badge/Version-1.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.23.2](https://img.shields.io/badge/AppVersion-0.23.2-informational?style=flat-square)

This is VeeCode DevPortal new Helm Chart, wrapping the official Backstage chart.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://backstage.github.io/charts | upstream(backstage) | 2.5.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.host | string | `""` | The external hostname for your DevPortal instance (e.g. https://myportal.apps.vee.codes) |
| upstream.backstage.appConfig.app.analytics | object | `{}` |  |
| upstream.backstage.appConfig.app.baseUrl | string | `"https://{{- include \"veecode.hostname\" . }}"` |  |
| upstream.backstage.appConfig.app.support.items[0].icon | string | `"github"` |  |
| upstream.backstage.appConfig.app.support.items[0].links[0].title | string | `"GitHub Issues"` |  |
| upstream.backstage.appConfig.app.support.items[0].links[0].url | string | `"https://github.com/veecode-platform/support/discussions"` |  |
| upstream.backstage.appConfig.app.support.items[0].title | string | `"Issues"` |  |
| upstream.backstage.appConfig.app.support.url | string | `"https://github.com/veecode-platform/support/discussions"` |  |
| upstream.backstage.appConfig.app.title | string | `"Veecode DevPortal"` |  |
| upstream.backstage.appConfig.auth | object | `{}` |  |
| upstream.backstage.appConfig.backend.baseUrl | string | `"https://{{- include \"veecode.hostname\" . }}"` |  |
| upstream.backstage.appConfig.backend.cors.origin | string | `"https://{{- include \"veecode.hostname\" . }}"` |  |
| upstream.backstage.appConfig.backend.csp.connect-src[0] | string | `"'self'"` |  |
| upstream.backstage.appConfig.backend.csp.connect-src[1] | string | `"http:"` |  |
| upstream.backstage.appConfig.backend.csp.connect-src[2] | string | `"https:"` |  |
| upstream.backstage.appConfig.backend.csp.img-src[0] | string | `"'self'"` |  |
| upstream.backstage.appConfig.backend.csp.img-src[1] | string | `"data:"` |  |
| upstream.backstage.appConfig.backend.csp.img-src[2] | string | `"https://raw.githubusercontent.com/"` |  |
| upstream.backstage.appConfig.backend.csp.img-src[3] | string | `"https://avatars.githubusercontent.com/"` |  |
| upstream.backstage.appConfig.backend.csp.img-src[4] | string | `"https://veecode-platform.github.io"` |  |
| upstream.backstage.appConfig.backend.csp.script-src[0] | string | `"'self'"` |  |
| upstream.backstage.appConfig.backend.csp.script-src[1] | string | `"'unsafe-eval'"` |  |
| upstream.backstage.appConfig.backend.csp.script-src[2] | string | `"https://www.google-analytics.com"` |  |
| upstream.backstage.appConfig.backend.csp.script-src[3] | string | `"https://www.googletagmanager.com"` |  |
| upstream.backstage.appConfig.backend.database.client | string | `"better-sqlite3"` |  |
| upstream.backstage.appConfig.backend.database.connection | string | `":memory:"` |  |
| upstream.backstage.appConfig.backend.listen.port | int | `7007` |  |
| upstream.backstage.appConfig.backend.logging.level | string | `"debug"` |  |
| upstream.backstage.appConfig.backend.reading.allow[0].host | string | `"example.com"` |  |
| upstream.backstage.appConfig.backend.reading.allow[1].host | string | `"*.mozilla.org"` |  |
| upstream.backstage.appConfig.catalog.orphanStrategy | string | `"delete"` |  |
| upstream.backstage.appConfig.catalog.providers | object | `{}` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[0] | string | `"Component"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[10] | string | `"User"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[1] | string | `"API"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[2] | string | `"Location"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[3] | string | `"Cluster"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[4] | string | `"Template"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[5] | string | `"Environment"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[6] | string | `"Database"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[7] | string | `"Vault"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[8] | string | `"Infracost"` |  |
| upstream.backstage.appConfig.catalog.rules[0].allow[9] | string | `"Group"` |  |
| upstream.backstage.appConfig.enabledPlugins.argocd | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.azureDevops | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.github | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.gitlab | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.gitlabPlugin | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.grafana | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.infracost | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.keycloak | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.kong | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.kubernetes | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.rbac | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.sonarqube | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.vault | bool | `false` |  |
| upstream.backstage.appConfig.enabledPlugins.vee | bool | `false` |  |
| upstream.backstage.appConfig.grafana.domain | string | `"grafana.localhost"` |  |
| upstream.backstage.appConfig.grafana.unifiedAlerting | bool | `true` |  |
| upstream.backstage.appConfig.integrations | object | `{}` |  |
| upstream.backstage.appConfig.organization.name | string | `"Veecode Platform Devportal"` |  |
| upstream.backstage.appConfig.permission.enabled | bool | `false` |  |
| upstream.backstage.appConfig.platform.apiManagement.enabled | bool | `false` |  |
| upstream.backstage.appConfig.platform.apiManagement.readOnlyMode | bool | `false` |  |
| upstream.backstage.appConfig.platform.behaviour.mode | string | `"product"` |  |
| upstream.backstage.appConfig.platform.defaultGroup.enabled | bool | `false` |  |
| upstream.backstage.appConfig.platform.group.admin | string | `"platform-admin"` |  |
| upstream.backstage.appConfig.platform.group.user | string | `"platform-user"` |  |
| upstream.backstage.appConfig.platform.guest.demo | bool | `false` |  |
| upstream.backstage.appConfig.platform.guest.enabled | bool | `false` |  |
| upstream.backstage.appConfig.platform.logo.full | string | `"https://veecode-platform.github.io/support/logos/logo.svg"` |  |
| upstream.backstage.appConfig.platform.logo.icon | string | `"https://veecode-platform.github.io/support/logos/logo-mobile.png"` |  |
| upstream.backstage.appConfig.platform.signInProviders | object | `{}` |  |
| upstream.backstage.appConfig.scaffolder.defaultAuthor.email | string | `"scaffolder@vee.codes"` |  |
| upstream.backstage.appConfig.scaffolder.defaultAuthor.name | string | `"Scaffolder"` |  |
| upstream.backstage.appConfig.scaffolder.defaultCommitMessage | string | `"initial project commit"` |  |
| upstream.backstage.appConfig.techdocs.builder | string | `"local"` |  |
| upstream.backstage.appConfig.techdocs.generator.runIn | string | `"local"` |  |
| upstream.backstage.appConfig.techdocs.publisher.type | string | `"local"` |  |
| upstream.backstage.extraEnvVars[0].name | string | `"LOG_LEVEL"` |  |
| upstream.backstage.extraEnvVars[0].value | string | `"debug"` |  |
| upstream.backstage.extraVolumeMounts[0].mountPath | string | `"/app/app-config.yaml"` |  |
| upstream.backstage.extraVolumeMounts[0].name | string | `"app-config"` |  |
| upstream.backstage.extraVolumeMounts[0].subPath | string | `"app-config.yaml"` |  |
| upstream.backstage.extraVolumes[0].configMap.name | string | `"veecode-devportal-upstream-app-config"` |  |
| upstream.backstage.extraVolumes[0].name | string | `"app-config"` |  |
| upstream.backstage.image.registry | string | `"docker.io"` | registry da imagem (default é o Docker Hub) |
| upstream.backstage.image.repository | string | `"veecode/devportal-bundle"` | nome da imagem |
| upstream.backstage.image.tag | string | `"0.23.2"` | tag da imagem |
| upstream.enabled | bool | `true` |  |
| upstream.postgresql.enabled | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)