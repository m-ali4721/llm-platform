module "vpc" {
  source = "../../modules/vpc"

  project_id    = var.project_id
  vpc_name      = "llm-platform-dev"
  region        = var.region
  router_name   = "llm-platform-dev-router"
  subnet_cidr   = "10.10.0.0/20"
  pods_cidr     = "10.20.0.0/16"
  services_cidr = "10.30.0.0/20"
}

module "gke" {
  source = "../../modules/eks"

  project_id          = var.project_id
  cluster_name        = "llm-platform-dev"
  region              = var.region
  network             = module.vpc.vpc_name
  subnetwork          = module.vpc.subnet_name
  pods_range_name     = "pods"
  services_range_name = "services"
  node_machine_type   = "e2-medium"
  min_nodes           = 1
  max_nodes           = 3
  release_channel     = "REGULAR"
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id = var.project_id
  region     = var.region
  repo_id    = "llm-platform"
}

module "hello_api_wi" {
  source = "../../modules/irsa"

  project_id          = var.project_id
  gsa_name            = "hello-api-gsa"
  k8s_namespace       = "hello-api"
  k8s_service_account = "hello-api"
  role_ids = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ]
}
