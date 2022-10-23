{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "names.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Kubernetes standard labels
*/}}
{{- define "labels.standard" -}}
app.kubernetes.io/name: {{ .Release.Name }}{{ if .Values.kptSetter -}}{{ " # kpt-set: ${app-name}" }}{{ end }}
{{- end -}}
