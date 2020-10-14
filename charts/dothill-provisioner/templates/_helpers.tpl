{{- define "dothill.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name | kebabcase }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: dynamic-provisionning
{{- end -}}

{{- define "dothill.extraArgs" -}}
{{- range .extraArgs }}
  - {{ toYaml . }}
{{- end }}
{{- end -}}