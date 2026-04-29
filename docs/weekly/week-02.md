# Week 2 — Apr 27 - May 3

## What I built

Converted hello-api to a Helm chart, added Dify community chart to the repo, and got Dify running end to end on kind. Also validated Dify on GKE, set up the staging Terraform environment, and scaffolded cert-manager manifests for Phase 2.

## Dify on kind

Took longer than expected. The main blocker was storage — kind doesn't have a ReadWriteMany storage class out of the box, so the api PVC was stuck pending. Fixed it by setting up an NFS provisioner on the kind cluster. Once storage was sorted, the rest came up cleanly.

## Dify on GKE

Hit a GCE CPU quota issue during the GKE session. The chart defaults deploy postgres read replicas, redis replicas, and weaviate which pushed resource requests beyond what the 4 nodes could schedule. Diagnosed it through scheduler events — the error was clear once I looked at the pod description. Didn't resolve it fully in session as the goal was just validation, not production-ready deployment. Destroyed clean.

## Chart as submodule

Initially added the Dify community chart as a git submodule which caused tracking issues in the parent repo. Removed the submodule and vendored the chart files directly — simpler for CI and GKE sessions.

## Next week

Phase 2 starts — ArgoCD on kind, Helm advanced patterns, then GitOps for Dify.
