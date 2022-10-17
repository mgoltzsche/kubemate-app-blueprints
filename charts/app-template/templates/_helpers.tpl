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
app.kubernetes.io/name: {{ .Release.Name }}
{{- end -}}

{{/*
Generates a full image name from an image object (param 0) and the chart version as fallback tag (param 1).
*/}}
{{- define "image.reference" -}}
{{- $img := (index . 0) -}}
{{- $fallbackTag := (index . 1) -}}
{{- $img.repository -}}:{{- $img.tag | default $fallbackTag -}}
{{- end -}}
