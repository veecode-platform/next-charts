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

{{/*
Returns custom protocol
*/}}
{{- define "veecode.protocol" -}}
    {{- if .Values.global.protocol -}}
        {{- .Values.global.protocol -}}
    {{- else -}}
        https
    {{- end -}}
{{- end -}}

{{/*
Returns custom port
*/}}
{{- define "veecode.port" -}}
    {{- if .Values.global.port -}}
        {{- .Values.global.port -}}
    {{- else -}}
        
    {{- end -}}
{{- end -}}

{{/*
Returns chosen image
*/}}
{{- define "veecode.image" -}}
    {{- if .Values.backstage.image.repository -}}
        {{- .Values.backstage.image.repository -}}
    {{- else -}}
        {{ fail "Backstage image repository is not set" }}
    {{- end -}}
{{- end -}}

{{/*
Returns chosen tag
*/}}
{{- define "veecode.tag" -}}
    {{- if .Values.backstage.image.tag -}}
        {{- .Values.backstage.image.tag -}}
    {{- else -}}
        {{ fail "Backstage image tag is not set" }}
    {{- end -}}
{{- end -}}
