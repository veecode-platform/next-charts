{{/* Helper template file */}}

{{/*
Returns custom hostname
*/}}
{{- define "veecode.hostname" -}}
    {{- if .Values.global.host -}}
        {{- .Values.global.host -}}
    {{- else -}}
        {{ fail "Unable to generate hostname (global.host is not set)" }}
    {{- end -}}
{{- end -}}
