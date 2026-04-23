variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "gsa_name" {
  type        = string
  description = "Google Service Account name"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace of the service account"
}

variable "k8s_service_account" {
  type        = string
  description = "Kubernetes service account name"
}

variable "role_id" {
  type        = string
  description = "IAM role to assign to the GSA"
}
