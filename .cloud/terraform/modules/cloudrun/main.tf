data google_project project {
  project_id = var.project
}

resource google_cloud_run_service cloudrun {
  name                       = var.service
  location                   = var.region
  autogenerate_revision_name = true
  project                    = data.google_project.project.project_id

  template {
    spec {
      containers {
        image = "eu.gcr.io/${var.project}/${var.service}"
        env {
          name  = "APP_ENV"
          value = "prod"
        }
        env {
          name  = "APP_DEBUG"
          value = "true"
        }
        env {
          name  = "PROJECT_ID"
          value = var.project
        }
      }
      service_account_name = var.service_account_email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = 1000
        "run.googleapis.com/cloudsql-instances" = var.database_instance
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data google_iam_policy noauth {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource google_cloud_run_service_iam_policy noauth {
  location = google_cloud_run_service.cloudrun.location
  project  = google_cloud_run_service.cloudrun.project
  service  = google_cloud_run_service.cloudrun.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
