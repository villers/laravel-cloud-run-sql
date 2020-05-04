provider google {
  project = var.project
}

module services {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "8.0.0"

  project_id = var.project

  activate_apis = [
    "run.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

module database {
  source = "./modules/database"

  project       = module.services.project_id
  service       = var.service
  region        = var.region
  instance_name = var.instance_name
}

module config {
  source = "./modules/config"

  project      = module.services.project_id
  service      = var.service
  region       = var.region
  database_url = module.database.database_url
}

module cloudrun {
  source = "./modules/cloudrun"

  project               = module.services.project_id
  service               = var.service
  region                = var.region
  database_instance     = module.database.database_instance
  service_account_email = module.config.service_account_email
}

output result {
  value = <<EOF
    The ${var.service} is now running at ${module.cloudrun.service_url}
    If you haven't deployed this service before, you will need to perform the initial database migrations:
    cd ../..
    gcloud builds submit --project ${var.project} --config .cloudbuild/build-migrate-deploy.yaml \
        --substitutions _APP_ENV=dev,_APP_DEBUG=true,_REGION=${var.region},_INSTANCE_NAME=${module.database.short_instance_name},_SERVICE=${var.service}

    The username and password are stored in these secrets:
    gcloud secrets versions access latest --secret DATABASE_URL
    ✨
    EOF
}
