{{- define "dothill.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name | kebabcase }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "dothill.extraArgs" -}}
{{- range .extraArgs }}
  - {{ toYaml . }}
{{- end }}
{{- end -}}