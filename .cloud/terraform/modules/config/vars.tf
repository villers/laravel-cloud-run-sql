variable project {
  type        = string
  description = "The Google Cloud Platform project name"
}

variable service {
  type        = string
  description = "Name of the service"
}

variable region {
  type = string
}

variable database_url {
  type        = string
  description = "The ODBC connection string"
}
