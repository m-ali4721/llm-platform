{{- define "hello-api.name" -}}
{{- .Chart.Name }}
{{- end }}

{{- define "hello-api.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hello-api.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{ include "hello-api.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hello-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "hello-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.name }}
{{- .Values.serviceAccount.name }}
{{- else }}
{{- include "hello-api.fullname" . }}
{{- end }}
{{- end }}
