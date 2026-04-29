# llm-platform

Production-grade LLM platform on GCP — Dify with self-hosted vLLM on GKE.

## Status

Phase 1 complete. Phase 2 in progress.

- Terraform modules for VPC, GKE, Workload Identity, Artifact Registry
- Dify deployed on kind (local) and validated on GKE
- hello-api retired after Workload Identity verification
- Staging environment configured
- cert-manager manifests scaffolded for Phase 2

## Stack

Infrastructure: Terraform, GCP (us-east1)
Cluster: GKE Standard
Identity: Workload Identity (no long-lived keys)
Registry: Artifact Registry
LLM Platform: Dify with self-hosted vLLM (Phase 4)
GitOps: ArgoCD (Phase 2)
Observability: Prometheus, Grafana, Loki (Phase 3)
CI/CD: GitHub Actions with Workload Identity Federation (Phase 5)

## Structure

```
apps/
  api/              FastAPI hello-api (retired after Phase 1)
  dify/             Dify Helm chart and environment values

infrastructure/
  environments/
    dev/            Dev GKE cluster (Terraform)
    staging/        Staging config (plan only, no apply)
  modules/
    vpc/            VPC, Cloud NAT, firewall rules
    eks/            GKE cluster and node pool
    irsa/           Workload Identity bindings
    artifact-registry/

platform/
  cert-manager/     ClusterIssuer manifests (applied in Phase 2)

docs/
  architecture.md
  aws-concept-mapping.md
  weekly/
  security/
```

## Deploy

```bash
cd infrastructure/environments/dev
terraform init
terraform apply
gcloud container clusters get-credentials llm-platform-dev --region us-east1
```

Always destroy after sessions:

```bash
terraform destroy -auto-approve
```
