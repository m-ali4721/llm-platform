output "repository_url" {
  description = "Docker image push/pull URL for this Artifact Registry repository"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_id}"
}
