# Week 1 — Apr 20-26

## What I built

Got the GCP foundation working this week — VPC, GKE, Artifact Registry, Workload Identity via Terraform, then deployed hello-api on GKE and verified everything end to end.

## Workload Identity

Was the main thing to get right. Exec'd into the pod, hit the metadata server, got back the GSA email — that confirmed the pod has its own GCP identity with no JSON keys anywhere.

## What slowed me down

Terraform depends_on for the WI binding — the Workload Identity pool doesn't exist until GKE is created so I had to add the dependency explicitly. And pip install --user in multi-stage Docker doesn't work in containers — packages end up somewhere Python ignores at runtime. Fixed with --prefix=/install copied to /usr/local.

## Next week

hello-api to Helm chart, then start on Dify.
