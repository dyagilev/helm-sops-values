{{- define "news.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "news.labels" -}}
{{ include "news.selectorLabels" . }}
app.kubernetes.io/environment: {{ .Values.env }}
app.kubernetes.io/component: {{ .Values.tier }}
service.type: spring
{{- end }}

{{- define "news.selectorLabels" -}}
app.kubernetes.io/app: {{ include "news.name" . }}
{{- end }}

{{- define "news.ingressAnnotations" -}}
kubernetes.io/ingress.class: {{ .Values.ingress.class }}
nginx.ingress.kubernetes.io/rewrite-target: /$2
{{- end }}
