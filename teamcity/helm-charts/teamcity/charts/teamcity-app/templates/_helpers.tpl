{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "teamcity.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "teamcity.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "teamcity.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "teamcity.serviceAccountName" -}}
{{-   if .Values.serviceAccount.create -}}
{{      default (include "teamcity.fullname" .) .Values.serviceAccount.name }}
{{-   else -}}
{{      default "default" .Values.serviceAccount.name }}
{{-   end -}}
{{- end -}}

{{/*
Create the name of the server data volume to use
*/}}
{{- define "teamcity.serverVolumeName" -}}
{{-   if .Values.pvc.server.name -}}
{{      .Values.pvc.server.name }}
{{-   else -}}
{{      default (include "teamcity.fullname" .) }}-server-data
{{-   end -}}
{{- end -}}

{{/*
Create the name of the agent data volume to use
*/}}
{{- define "teamcity.agentVolumeName" -}}
{{-   if .Values.pvc.agent.name -}}
{{      .Values.pvc.agent.name }}
{{-   else -}}
{{      default (include "teamcity.fullname" .) }}-agent-data
{{-   end -}}
{{- end -}}

{{/*
Create the name of the server configmap
*/}}
{{- define "teamcity.serverSecret" -}}
{{  default (include "teamcity.fullname" .) }}-secret
{{- end -}}

