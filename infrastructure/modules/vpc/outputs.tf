output "vpc_name" {
  description = "VPC Name of this project"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  description = "VPC ID of this project"
  value       = google_compute_network.vpc.id
}

output "subnet_name" {
  description = "Subnet name of this project"
  value       = google_compute_subnetwork.private.name
}

output "subnet_id" {
  description = "Subnet ID of this VPC"
  value       = google_compute_subnetwork.private.id
}

output "router_name" {
  description = "Name of the router"
  value       = google_compute_router.router.name
}

output "nat_name" {
  description = "Name of NAT"
  value       = google_compute_router_nat.nat.name
}