locals {
  database_user = var.service
  database_name = var.service
}

resource random_password database_user_password {
  length  = 30
  special = false
}

resource google_sql_database_instance sql {
  name             = var.instance_name
  database_version = "MYSQL_5_7"
  region           = var.region
  project          = var.project

  settings {
    tier      = "db-f1-micro"
    disk_type = "PD_HDD"
  }
}

resource google_sql_database database {
  name     = local.database_name
  instance = google_sql_database_instance.sql.name
}

resource google_sql_user user {
  name     = local.database_user
  instance = google_sql_database_instance.sql.name
  password = random_password.database_user_password.result
}
