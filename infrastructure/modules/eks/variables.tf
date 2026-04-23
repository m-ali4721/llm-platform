variable "cluster_name" {
  type        = string
  description = "GKE cluster name"
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "network" {
  type        = string
  description = "VPC network name"
}

variable "subnetwork" {
  type        = string
  description = "Subnet name"
}

variable "pods_range_name" {
  type        = string
  description = "Secondary range name for GKE pods"
}

variable "services_range_name" {
  type        = string
  description = "Secondary range name for GKE services"
}

variable "node_machine_type" {
  type        = string
  description = "Machine type for nodes"
}

variable "min_nodes" {
  type        = number
  description = "Minimum nodes per zone"
}

variable "max_nodes" {
  type        = number
  description = "Maximum nodes per zone"
}

variable "release_channel" {
  type        = string
  description = "GKE release channel (REGULAR, STABLE, RAPID)"
  default     = "REGULAR"
}