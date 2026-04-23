resource "google_service_account" "gsa" {
  account_id   = var.gsa_name
  project      = var.project_id
  display_name = "${var.gsa_name} for Workload Identity"
}

resource "google_project_iam_member" "roles" {
  for_each = toset(var.role_ids)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account}]",
  ]
}
