resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Default node pool remove karte hain — apna managed node pool alag banayenge
  remove_default_node_pool = true
  initial_node_count       = 1

  # VPC aur subnet reference
  network    = var.network
  subnetwork = var.subnetwork

  # VPC-native mode — pods/services ko secondary IP ranges milein
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  # Workload Identity — pods ko GCP IAM identity milti hai, no key files
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Private nodes — nodes ka public IP nahi hoga, NAT se bahar jaayenge
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # API server public rehega (learning ke liye)
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # GKE version channel — REGULAR = stable + timely updates
  release_channel {
    channel = var.release_channel
  }

  # Network policies enable (Calico CNI) — pod-to-pod traffic control
  network_policy {
    enabled = true
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  # Logging aur monitoring GKE ko dete hain — Cloud Logging/Monitoring integrate hoti hai
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}
