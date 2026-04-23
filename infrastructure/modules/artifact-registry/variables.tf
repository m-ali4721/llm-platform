variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region for the Artifact Registry repository"
}

variable "repo_id" {
  type        = string
  description = "Repository ID — last segment of the registry URL"
}
