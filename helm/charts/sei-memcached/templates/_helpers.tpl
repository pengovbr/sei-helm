{{/*
Expand the name of the chart.
*/}}
{{- define "sei-memcached.name" -}}
{{- default .Chart.Name .Values.memcached.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sei-memcached.fullname" -}}
{{- if .Values.memcached.fullnameOverride }}
{{- .Values.memcached.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.memcached.nameOverride }}
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
{{- define "sei-memcached.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sei-memcached.labels" -}}
helm.sh/chart: {{ include "sei-memcached.chart" . }}
{{ include "sei-memcached.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sei-memcached.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sei-memcached.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
