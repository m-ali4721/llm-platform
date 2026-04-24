# llm-platform

Production-grade LLM platform on GCP — Dify + self-hosted vLLM on GKE.

## Current Status

**Phase 1 — Week 1 complete**
- GKE cluster via Terraform (VPC, GKE, Workload Identity, Artifact Registry)
- hello-api deployed on GKE with Workload Identity verified
- Docker senior patterns (multi-stage, non-root, Trivy scanned)

## Stack

| Layer | Technology |
|-------|-----------|
| Infrastructure | Terraform, GCP |
| Container Runtime | GKE Standard (us-east1) |
| Identity | Workload Identity (no long-lived keys) |
| Registry | Artifact Registry |
| App (Phase 1) | FastAPI (hello-api) |
| App (Phase 2+) | Dify + self-hosted vLLM |
| GitOps | ArgoCD (Phase 2) |
| Observability | Prometheus + Grafana + Loki (Phase 3) |
| CI/CD | GitHub Actions + Workload Identity Federation (Phase 5) |

## Repository Structure

```
.
├── apps/
│   └── api/                  # hello-api (FastAPI)
│       ├── Dockerfile
│       ├── src/
│       └── k8s/              # Kubernetes manifests
├── infrastructure/
│   ├── environments/
│   │   ├── dev/              # Dev environment (Terraform)
│   │   └── staging/          # Staging environment
│   └── modules/
│       ├── vpc/              # VPC + NAT + Firewall
│       ├── eks/              # GKE cluster + node pool
│       ├── irsa/             # Workload Identity helper
│       └── artifact-registry/ # Artifact Registry
└── docs/
    ├── architecture.md
    ├── weekly/               # Weekly progress notes
    └── security/             # Trivy + Checkov scan reports
```

## Deploy

```bash
cd infrastructure/environments/dev
terraform init
terraform apply
```

```bash
gcloud container clusters get-credentials llm-platform-dev --region us-east1
kubectl apply -f apps/api/k8s/
```

**Always destroy after sessions:**
```bash
kubectl delete -f apps/api/k8s/
terraform destroy -auto-approve
```

## Docs

- [Architecture](docs/architecture.md)
- [Weekly Notes](docs/weekly/)
