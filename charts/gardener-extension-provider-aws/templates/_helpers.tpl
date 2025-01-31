{{- define "name" -}}
gardener-extension-provider-aws
{{- end -}}

{{- define "labels.app.key" -}}
app.kubernetes.io/name
{{- end -}}
{{- define "labels.app.value" -}}
{{ include "name" . }}
{{- end -}}

{{- define "labels" -}}
{{ include "labels.app.key" . }}: {{ include "labels.app.value" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{-  define "image" -}}
  {{- if hasPrefix "sha256:" .Values.image.tag }}
  {{- printf "%s@%s" .Values.image.repository .Values.image.tag }}
  {{- else }}
  {{- printf "%s:%s" .Values.image.repository .Values.image.tag }}
  {{- end }}
{{- end }}

{{- define "images.alpine" -}}
    {{- if .Values.images.alpine }}
      {{- .Values.images.alpine }}
    {{- else }}
      {{- include "image.alpine" .  }}
    {{- end }}
{{- end }}

{{- define "images.pause" -}}
    {{- if .Values.images.pause }}
      {{- .Values.images.pause }}
    {{- else }}
      {{- include "image.pause" .  }}
    {{- end }}
{{- end -}}

{{- define "deploymentversion" -}}
apps/v1
{{- end -}}

{{- define "priorityclassversion" -}}
{{- if semverCompare ">= 1.14-0" .Capabilities.KubeVersion.GitVersion -}}
scheduling.k8s.io/v1
{{- else if semverCompare ">= 1.11-0" .Capabilities.KubeVersion.GitVersion -}}
scheduling.k8s.io/v1beta1
{{- else -}}
scheduling.k8s.io/v1alpha1
{{- end -}}
{{- end -}}