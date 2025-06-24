
Veecode-devportal
===========

Parent Helm Chart for VeeCode DevPortal, wrapping the official Backstage chart


## Configuration

The following table lists the configurable parameters of the Veecode-devportal chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `global.host` |  | `""` |
| `upstream.enabled` |  | `true` |
| `upstream.postgresql.enabled` |  | `false` |
| `upstream.backstage.image.registry` |  | `"docker.io"` |
| `upstream.backstage.image.repository` |  | `"veecode/devportal-bundle"` |
| `upstream.backstage.image.tag` |  | `"0.23.2"` |
| `upstream.backstage.extraEnvVars` |  | `[{"name": "LOG_LEVEL", "value": "debug"}]` |
| `upstream.backstage.extraVolumes` |  | `[{"name": "app-config", "configMap": {"name": "veecode-devportal-upstream-app-config"}}]` |
| `upstream.backstage.extraVolumeMounts` |  | `[{"name": "app-config", "mountPath": "/app/app-config.yaml", "subPath": "app-config.yaml"}]` |
| `upstream.backstage.appConfig.auth` |  | `null` |
| `upstream.backstage.appConfig.app.title` |  | `"Veecode DevPortal"` |
| `upstream.backstage.appConfig.app.baseUrl` |  | `"https://- include \"veecode.hostname\" . "` |
| `upstream.backstage.appConfig.app.support.url` |  | `"https://github.com/veecode-platform/support/discussions"` |
| `upstream.backstage.appConfig.app.support.items` |  | `[{"title": "Issues", "icon": "github", "links": [{"url": "https://github.com/veecode-platform/support/discussions", "title": "GitHub Issues"}]}]` |
| `upstream.backstage.appConfig.app.analytics` |  | `null` |
| `upstream.backstage.appConfig.grafana.domain` |  | `"grafana.localhost"` |
| `upstream.backstage.appConfig.grafana.unifiedAlerting` |  | `true` |
| `upstream.backstage.appConfig.backend.baseUrl` |  | `"https://- include \"veecode.hostname\" . "` |
| `upstream.backstage.appConfig.backend.listen.port` |  | `7007` |
| `upstream.backstage.appConfig.backend.logging.level` |  | `"debug"` |
| `upstream.backstage.appConfig.backend.cors.origin` |  | `"https://- include \"veecode.hostname\" . "` |
| `upstream.backstage.appConfig.backend.csp.connect-src` |  | `["'self'", "http:", "https:"]` |
| `upstream.backstage.appConfig.backend.csp.img-src` |  | `["'self'", "data:", "https://raw.githubusercontent.com/", "https://avatars.githubusercontent.com/", "https://veecode-platform.github.io"]` |
| `upstream.backstage.appConfig.backend.csp.script-src` |  | `["'self'", "'unsafe-eval'", "https://www.google-analytics.com", "https://www.googletagmanager.com"]` |
| `upstream.backstage.appConfig.backend.reading.allow` |  | `[{"host": "example.com"}, {"host": "*.mozilla.org"}]` |
| `upstream.backstage.appConfig.backend.database.client` |  | `"better-sqlite3"` |
| `upstream.backstage.appConfig.backend.database.connection` |  | `":memory:"` |
| `upstream.backstage.appConfig.organization.name` |  | `"Veecode Platform Devportal"` |
| `upstream.backstage.appConfig.techdocs.builder` |  | `"local"` |
| `upstream.backstage.appConfig.techdocs.generator.runIn` |  | `"local"` |
| `upstream.backstage.appConfig.techdocs.publisher.type` |  | `"local"` |
| `upstream.backstage.appConfig.integrations` |  | `null` |
| `upstream.backstage.appConfig.scaffolder.defaultAuthor.name` |  | `"Scaffolder"` |
| `upstream.backstage.appConfig.scaffolder.defaultAuthor.email` |  | `"scaffolder@vee.codes"` |
| `upstream.backstage.appConfig.scaffolder.defaultCommitMessage` |  | `"initial project commit"` |
| `upstream.backstage.appConfig.catalog.orphanStrategy` |  | `"delete"` |
| `upstream.backstage.appConfig.catalog.rules` |  | `[{"allow": ["Component", "API", "Location", "Cluster", "Template", "Environment", "Database", "Vault", "Infracost", "Group", "User"]}]` |
| `upstream.backstage.appConfig.catalog.providers` |  | `null` |
| `upstream.backstage.appConfig.enabledPlugins.rbac` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.vault` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.grafana` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.kubernetes` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.argocd` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.gitlabPlugin` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.keycloak` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.azureDevops` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.infracost` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.kong` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.vee` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.sonarqube` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.gitlab` |  | `false` |
| `upstream.backstage.appConfig.enabledPlugins.github` |  | `false` |
| `upstream.backstage.appConfig.permission.enabled` |  | `false` |
| `upstream.backstage.appConfig.platform.signInProviders` |  | `null` |
| `upstream.backstage.appConfig.platform.guest.enabled` |  | `false` |
| `upstream.backstage.appConfig.platform.guest.demo` |  | `false` |
| `upstream.backstage.appConfig.platform.apiManagement.enabled` |  | `false` |
| `upstream.backstage.appConfig.platform.apiManagement.readOnlyMode` |  | `false` |
| `upstream.backstage.appConfig.platform.defaultGroup.enabled` |  | `false` |
| `upstream.backstage.appConfig.platform.group.admin` |  | `"platform-admin"` |
| `upstream.backstage.appConfig.platform.group.user` |  | `"platform-user"` |
| `upstream.backstage.appConfig.platform.behaviour.mode` |  | `"product"` |
| `upstream.backstage.appConfig.platform.logo.icon` |  | `"https://veecode-platform.github.io/support/logos/logo-mobile.png"` |
| `upstream.backstage.appConfig.platform.logo.full` |  | `"https://veecode-platform.github.io/support/logos/logo.svg"` |





