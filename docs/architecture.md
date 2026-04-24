# Architecture

## Networking

Custom VPC in us-east1 with a single private subnet (10.10.0.0/20). GKE needs two secondary ranges on the subnet — one for pods (10.20.0.0/16) and one for services (10.30.0.0/20). Private nodes can't reach the internet directly so Cloud Router + Cloud NAT handle outbound traffic. Two firewall rules: allow internal traffic within the VPC, and allow IAP SSH (35.235.240.0/20) so I can SSH into nodes without a public IP.

## GKE Cluster

Standard mode cluster in us-east1 (regional = multi-zone). Private nodes with a public API endpoint — private nodes keep node IPs off the internet, public endpoint lets me run kubectl from my laptop. Workload Identity is enabled at cluster level and GKE_METADATA mode is set on the node pool so pods can use it. Spot VMs on e2-medium to save credits.

## Workload Identity

The whole point is pods get GCP credentials without any JSON key files. Flow:

1. K8s ServiceAccount has an annotation pointing to a Google Service Account (GSA)
2. Terraform creates that GSA and binds it to the K8s SA via roles/iam.workloadIdentityUser
3. When the pod makes a GCP API call, GKE's metadata server exchanges the K8s SA token for a short-lived GSA token automatically

Verified by exec'ing into a pod and hitting the metadata server — it returned hello-api-gsa@... not the node's default SA. AWS equivalent is IRSA — same idea, different names.

## Artifact Registry

Docker registry in us-east1. Immutable tags so nothing can overwrite an existing image version. Cleanup policy keeps the last 10 tags per image and deletes the rest automatically.

## hello-api request flow

Internet → Cloud Load Balancer → hello-api Service (port 80) → Pods (port 8000)

The LoadBalancer Service type automatically provisions a Cloud LB in GCP. Pods run as non-root (uid 1000), readOnlyRootFilesystem, all Linux capabilities dropped.

## AWS mapping

Workload Identity is IRSA on AWS — same concept, pod gets cloud credentials via a K8s SA binding with no static keys. Artifact Registry is ECR. Cloud Load Balancer maps to ALB. Cloud NAT is NAT Gateway. GKE Standard is EKS.
