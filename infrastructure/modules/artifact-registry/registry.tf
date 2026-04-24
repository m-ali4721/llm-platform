resource "google_artifact_registry_repository" "image-repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repo_id
  description   = "GKE focused image repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }

  cleanup_policies {
    id     = "keep-last-10"
    action = "KEEP"
    most_recent_versions {
      keep_count = 10
    }
  }
}
