data google_project project {
  project_id = var.project
}

data google_service_account deployer {
  project    = var.project
  account_id = "deployer"
}

locals {
  cloudrun_sa   = "serviceAccount:${google_service_account.cloudrun.email}"
  cloudbuild_sa = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  terraform_sa  = "serviceAccount:${data.google_service_account.deployer.email}"
}

resource google_service_account cloudrun {
  account_id   = var.service
  display_name = "${var.service} service account"
}

resource google_project_iam_binding service_permissions {
  for_each = toset([
    "run.admin", "cloudsql.client"
  ])

  role       = "roles/${each.key}"
  members    = [local.cloudbuild_sa, local.cloudrun_sa]
  depends_on = [google_service_account.cloudrun]
}

resource google_service_account_iam_binding cloudbuild_sa {
  service_account_id = google_service_account.cloudrun.name
  role               = "roles/iam.serviceAccountUser"

  members = [local.cloudbuild_sa]
}
