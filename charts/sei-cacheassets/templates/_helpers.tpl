{{/*
Expand the name of the chart.
*/}}
{{- define "sei-cacheassets.name" -}}
{{- default .Chart.Name .Values.cacheassets.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sei-cacheassets.fullname" -}}
{{- if .Values.cacheassets.fullnameOverride }}
{{- .Values.cacheassets.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.cacheassets.nameOverride }}
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
{{- define "sei-cacheassets.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sei-cacheassets.labels" -}}
helm.sh/chart: {{ include "sei-cacheassets.chart" . }}
{{ include "sei-cacheassets.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sei-cacheassets.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sei-cacheassets.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
