# Dify on kind — Debug Log

## Issue 1: PVC stuck in Pending (ReadWriteMany)

Symptom: `dify-api`, `dify-worker`, `dify-plugin-daemon` pods stuck in `Pending` state.

Root cause: Dify shares a single PVC between api, worker and plugin-daemon pods — which requires ReadWriteMany (RWX) access mode. kind's default storage class (local-path) only supports ReadWriteOnce (RWO).

How we found it:
```bash
kubectl describe pvc dify -n dify | grep -A 10 Events
# Output: Only support ReadWriteOnce access mode
```

Fix: Installed NFS server provisioner inside the cluster — creates an `nfs` StorageClass that supports RWX.
```bash
helm install nfs-server nfs-ganesha/nfs-server-provisioner \
  --namespace nfs-provisioner --create-namespace \
  --set persistence.enabled=true \
  --set persistence.storageClass=standard \
  --set persistence.size=10Gi
```

## Issue 2: StorageClass not set in values

Symptom: Even after NFS provisioner install, PVCs still used `standard` class.

Fix: Explicitly set `storageClass: nfs` in `values-dev.yaml` for `api` and `pluginDaemon` persistence sections.

## Result

All 14 pods running. Dify UI accessible at `http://localhost:9091` via port-forward.


