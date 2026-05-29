{{/* Chart name */}}
{{- define "veecode-devportal-platform.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Fully qualified app name */}}
{{- define "veecode-devportal-platform.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Chart label */}}
{{- define "veecode-devportal-platform.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "veecode-devportal-platform.labels" -}}
helm.sh/chart: {{ include "veecode-devportal-platform.chart" . }}
{{ include "veecode-devportal-platform.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels */}}
{{- define "veecode-devportal-platform.selectorLabels" -}}
app.kubernetes.io/name: {{ include "veecode-devportal-platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Service account name */}}
{{- define "veecode-devportal-platform.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "veecode-devportal-platform.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/* Name of the credentials Secret (existing if set, else the chart-managed one) */}}
{{- define "veecode-devportal-platform.secretName" -}}
{{- if .Values.existingSecret -}}
{{- .Values.existingSecret -}}
{{- else -}}
{{- printf "%s-credentials" (include "veecode-devportal-platform.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/* "true" when any credentials source is configured (created secret or referenced existing) */}}
{{- define "veecode-devportal-platform.hasCredentials" -}}
{{- if or .Values.existingSecret (gt (len .Values.credentials) 0) -}}true{{- end -}}
{{- end -}}
