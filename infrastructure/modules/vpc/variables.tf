variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC network"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "subnet_cidr" {
  type        = string
  description = "Primary CIDR range for the subnet"
}

variable "pods_cidr" {
  type        = string
  description = "Secondary CIDR range for GKE pods"
}

variable "services_cidr" {
  type        = string
  description = "Secondary CIDR range for GKE services"
}

variable "router_name" {
  type        = string
  description = "Name of the router"
}