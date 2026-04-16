{{/*
Expand the name of the chart.
*/}}
{{- define "escapecloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "escapecloud.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "escapecloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "escapecloud.labels" -}}
helm.sh/chart: {{ include "escapecloud.chart" . }}
{{ include "escapecloud.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "escapecloud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "escapecloud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the web config map name.
*/}}
{{- define "escapecloud.webConfigMapName" -}}
{{- printf "%s-web-config" (include "escapecloud.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the web secret name.
*/}}
{{- define "escapecloud.webSecretName" -}}
{{- printf "%s-web-secret" (include "escapecloud.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the engine config map name.
*/}}
{{- define "escapecloud.engineConfigMapName" -}}
{{- printf "%s-engine-config" (include "escapecloud.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the engine secret name.
*/}}
{{- define "escapecloud.engineSecretName" -}}
{{- printf "%s-engine-secret" (include "escapecloud.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the webapp deployment and service base name.
*/}}
{{- define "escapecloud.webappName" -}}
{{- printf "%s-webapp" (include "escapecloud.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the API deployment and service base name.
*/}}
{{- define "escapecloud.apiName" -}}
{{- printf "%s-api" (include "escapecloud.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
