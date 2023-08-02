resource "google_sql_database_instance" "instance" {
  name                = var.instance_name
  region              = var.region
  database_version    = var.database_version
  project             = var.project
  deletion_protection = var.deletion_protection

  settings {
    tier                  = var.instance_type
    disk_size             = var.disk_size
    disk_type             = var.disk_type
    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    user_labels           = var.environment
    availability_type     = var.zone_availability_type

    database_flags {
      name  = "max_connections"
      value = var.max_connections
    }

    backup_configuration {
      enabled    = "true"
      start_time = "01:00"
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    ip_configuration {
      ipv4_enabled       = var.ipv4_enabled
      private_network    = "projects/${var.project}/global/networks/${var.vpc_network}"
      allocated_ip_range = var.allocated_ip_range
    }

    dynamic "insights_config" {
      for_each = var.insights_config != null ? [var.insights_config] : []

      content {
        query_insights_enabled  = true
        query_string_length     = lookup(insights_config.value, "query_string_length", 1024)
        record_application_tags = lookup(insights_config.value, "record_application_tags", false)
        record_client_address   = lookup(insights_config.value, "record_client_address", false)
      }
    }

  }
  lifecycle {
    ignore_changes = []
  }

}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

provider "google-beta" {
  region = var.region
  zone   = var.zone
}

resource "random_password" "pgsql_password" {
  length  = 16
  special = false
}

resource "google_sql_user" "postgres" {
  project  = var.project
  name     = "postgres"
  instance = google_sql_database_instance.instance.name
  password = random_password.pgsql_password.result
}

resource "google_sql_database" "db" {
  project  = var.project
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_secret_manager_secret" "postgres_credential" {
  project   = var.project
  secret_id = "postgres_credential"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "postgres_credential_version" {
  secret      = google_secret_manager_secret.postgres_credential.id
  secret_data = "postgresql://postgres:${google_sql_user.postgres.password}@${google_sql_database_instance.instance.private_ip_address}"
}