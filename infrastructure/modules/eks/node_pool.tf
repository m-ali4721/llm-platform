resource "google_container_node_pool" "primary" {
  name     = "${var.cluster_name}-primary"
  location = var.region
  cluster  = google_container_cluster.primary.name

  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.node_machine_type

    # Spot VMs — learning discount, ~60-70% cheaper
    spot = true

    # Workload Identity ke liye zaroori — node metadata GKE format mein expose karta hai
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Minimal scopes — actual permissions Workload Identity handle karega
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Shielded nodes — secure boot + integrity monitoring (security baseline)
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    labels = {
      env = "dev"
    }

    tags = ["gke-node", "dev"]
  }
}
