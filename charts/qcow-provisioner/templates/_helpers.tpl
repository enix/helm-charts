{{- define "qcow.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name | kebabcase }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: dynamic-provisionning
{{- end -}}
