locals {
  // HA method using REGIONAL availability_type requires binary logs to be enabled
  binary_log_enabled = var.zone_availability_type == "REGIONAL" ? true : lookup(var.backup_configuration, "binary_log_enabled", null)
  backups_enabled    = var.zone_availability_type == "REGIONAL" ? true : lookup(var.backup_configuration, "enabled", null)

  retained_backups = lookup(var.backup_configuration, "retained_backups", null)
  retention_unit   = lookup(var.backup_configuration, "retention_unit", null)
}

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
    user_labels           = var.user_labels
    availability_type     = var.zone_availability_type

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    dynamic "backup_configuration" {
      for_each = [var.backup_configuration]
      content {
        binary_log_enabled             = local.binary_log_enabled
        enabled                        = local.backups_enabled
        start_time                     = lookup(backup_configuration.value, "start_time", null)
        location                       = lookup(backup_configuration.value, "location", null)
        transaction_log_retention_days = lookup(backup_configuration.value, "transaction_log_retention_days", null)

        dynamic "backup_retention_settings" {
          for_each = local.retained_backups != null || local.retention_unit != null ? [var.backup_configuration] : []
          content {
            retained_backups = local.retained_backups
            retention_unit   = local.retention_unit
          }
        }
      }
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    ip_configuration {
      ipv4_enabled       = var.ipv4_enabled
      private_network    = "projects/${var.network_project}/global/networks/${var.vpc_network}"
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

resource "random_password" "user-password" {
  keepers = {
    name = google_sql_database_instance.instance.name
  }
  length  = 16
  special = false
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.instance]
}

resource "google_sql_user" "default" {
  count    = var.enable_default_user ? 1 : 0
  project  = var.project
  name     = var.user_name
  instance = google_sql_database_instance.instance.name
  host     = var.user_host
  password = random_password.user-password.result
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.instance,
  ]
}

resource "google_sql_database" "db" {
  count      = var.enable_default_db ? 1 : 0
  project    = var.project
  name       = var.database_name
  instance   = google_sql_database_instance.instance.name
  charset    = var.db_charset
  collation  = var.db_collation
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.instance]
}

resource "google_secret_manager_secret" "db_credential" {
  project   = var.project
  secret_id = "mysql_credential"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "db_credential_version" {
  count       = var.enable_default_user ? 1 : 0
  secret      = google_secret_manager_secret.db_credential.id
  secret_data = "mysql://${google_sql_user.default[0].name}:${google_sql_user.default[0].password}@${google_sql_database_instance.instance.private_ip_address}"
}
