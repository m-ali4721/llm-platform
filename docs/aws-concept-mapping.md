# AWS Concept Mapping

Every GCP pattern in this project mapped to its AWS equivalent. Built on GCP but the underlying concepts translate directly.

---

## Pod-to-cloud identity

GCP: Workload Identity
AWS: IRSA (IAM Roles for Service Accounts)

Both bind a Kubernetes service account to a cloud IAM identity so pods can call cloud APIs without credentials in environment variables or mounted secrets.

GCP flow: pod uses GKE metadata server to get a short-lived token for a Google Service Account. The binding is a GSA IAM policy that allows a specific KSA (identified by project.svc.id.goog[namespace/ksa-name]) to impersonate the GSA.

AWS flow: pod uses the projected service account token (OIDC) to assume an IAM role. The role trust policy allows the OIDC provider to federate, scoped to a specific namespace and service account.

Key difference: GCP uses service account impersonation, AWS uses role assumption. The result is identical — short-lived credentials, no secrets to rotate.

Terraform in this repo: infrastructure/modules/irsa/

---

## Container registry

GCP: Artifact Registry
AWS: ECR (Elastic Container Registry)

Both store Docker images and integrate natively with their cluster (GKE/EKS pulls without explicit credentials because the node's identity has registry read access).

GCP: node pool OAuth scope includes storage read, or Workload Identity grants artifactregistry.reader.
AWS: node instance role gets AmazonEC2ContainerRegistryReadOnly.

Cleanup policy in this repo keeps the last 10 image versions. ECR lifecycle policies do the same.

Terraform in this repo: infrastructure/modules/artifact-registry/

---

## Networking — VPC

GCP: VPC with custom subnet, secondary IP ranges for pods and services, Cloud NAT for egress.
AWS: VPC with public/private subnets, NAT Gateway for egress.

Key GCP difference: pod and service CIDRs are secondary ranges on the same subnet, not separate subnets. This is VPC-native networking (alias IPs) — pods get real VPC IPs routable without an overlay.

AWS equivalent: VPC CNI plugin also assigns real VPC IPs to pods from the node's subnet.

Cloud NAT vs NAT Gateway: both are managed, no EC2 instance to maintain. GCP Cloud NAT is regional and auto-allocates IPs. AWS NAT Gateway is per-AZ and requires an Elastic IP.

Terraform in this repo: infrastructure/modules/vpc/

---

## Kubernetes cluster

GCP: GKE Standard
AWS: EKS

Control plane is managed in both. Key differences:

GKE Standard gives more control over node pools, upgrade channels, and add-ons. GKE Autopilot (not used here) is closer to Fargate — fully managed nodes.

EKS requires explicit node group management (managed node groups or self-managed). Fargate profiles offload node management entirely.

Release channels in GKE (RAPID, REGULAR, STABLE) map roughly to EKS's Kubernetes version support tiers.

Workload Identity is enabled at cluster creation via workload_pool = project.svc.id.goog. IRSA requires an OIDC provider to be created and associated with the EKS cluster.

---

## Load balancing and ingress

GCP: Cloud Load Balancing, NGINX ingress controller
AWS: ALB (Application Load Balancer), AWS Load Balancer Controller

In this project, NGINX ingress creates a Cloud L4 load balancer (TCP passthrough) that routes to the NGINX pods, which then route to services via ingress rules.

AWS equivalent: AWS Load Balancer Controller creates an ALB directly from ingress resources using annotations. No intermediate NGINX layer needed if using ALB ingress.

For TLS: cert-manager (Phase 2) handles certificate provisioning via Let's Encrypt in both clouds. AWS alternative is ACM with ALB — certificates are managed entirely by AWS with no cert-manager needed.

---

## Secrets management

GCP: Secret Manager with External Secrets Operator
AWS: Secrets Manager or Parameter Store with External Secrets Operator

ESO is cloud-agnostic. The ClusterSecretStore points to the cloud provider, SecretStore defines the auth method, ExternalSecret defines what to sync into a Kubernetes Secret.

GCP auth: ESO uses Workload Identity to call Secret Manager API — no credentials needed.
AWS auth: ESO uses IRSA to call Secrets Manager — same pattern, different provider name in the spec.

ESO is introduced in Phase 2 of this project.

---

## Node autoscaling

GCP: Node Auto-Provisioning (NAP)
AWS: Karpenter

Both provision nodes on demand based on pending pod requirements and deprovision idle nodes.

NAP is GKE's built-in autoprovisioner. It creates node pools automatically based on pod resource requests and node selectors. Karpenter on EKS does the same but with more flexibility around instance type selection and consolidation.

Cluster Autoscaler (used in Phase 1 here) scales existing node pools up and down. NAP goes further by creating new node pools with the right machine type. Phase 3 adds NAP configuration.

---

## Managed databases

GCP: Cloud SQL (Postgres), Memorystore (Redis)
AWS: RDS (Postgres), ElastiCache (Redis)

Migration from self-hosted StatefulSets to managed services is the Phase 3 story. Both clouds offer private IP access via VPC peering (GCP: Private Service Access, AWS: VPC peering with the service VPC).

Workload Identity auth to Cloud SQL: Cloud SQL Auth Proxy sidecar uses the pod's GSA to authenticate — no password in environment variables.
AWS equivalent: RDS IAM authentication with an IAM role granted rds-db:connect.

---

## CI/CD identity federation

GCP: Workload Identity Federation for GitHub Actions
AWS: OIDC provider for GitHub Actions IAM role

Both allow GitHub Actions to assume a cloud identity using a short-lived OIDC token from GitHub — no long-lived cloud credentials stored in GitHub secrets.

GCP: create a Workload Identity Pool, add GitHub as an OIDC provider, bind the pool to a GSA.
AWS: create an IAM OIDC provider for token.actions.githubusercontent.com, create an IAM role with a trust policy scoped to the repo and branch.

The GitHub Actions workflow step is nearly identical in both — use the official auth action, pass the provider and service account (GCP) or role ARN (AWS).

Introduced in Phase 5 of this project.

---

## Image and IaC scanning

GCP/AWS: Trivy for image scanning, Checkov for Terraform scanning — both tools are cloud-agnostic.

Trivy scans container images. In this project, the Dockerfile.bad vs Dockerfile comparison demonstrates the impact of base image choice and multi-stage builds on vulnerability surface.

Checkov scans Terraform for misconfigurations. Findings are documented in docs/security/scan-reports/.
