module secret_database_url {
  source  = "../secret"
  project = var.project

  name        = "DATABASE_URL"
  secret_data = var.database_url
  accessors   = [local.cloudbuild_sa, local.cloudrun_sa]
}

resource random_id app_key {
  byte_length = 32
}

module secret_app_key {
  source  = "../secret"
  project = var.project

  name        = "APP_KEY"
  secret_data = "base64:${random_id.app_key.b64_std}"
  accessors   = [local.cloudbuild_sa, local.cloudrun_sa]
}
