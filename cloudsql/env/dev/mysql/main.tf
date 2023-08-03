terraform {
  required_version = ">=0.14"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.4.0, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.4.0, < 5.0"
    }
  }
  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-sql-db:mysql/v12.0.0"
  }
  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-sql-db:mysql/v12.0.0"
  }
  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/cloudsql/dev/mysql/"
  }
}


module "default" {
  source                = "../../../modules/cloudsql-mysql/"
  instance_name         = "dev-mysql"
  instance_type         = "db-g1-small"
  region                = "asia-southeast2"
  zone                  = "asia-southeast2-a"
  network_project       = "cukzlearn03"
  vpc_network           = "vpc-dev"
  database_version      = "MYSQL_5_7"
  project               = "cukzlearn03"
  disk_autoresize       = true
  disk_autoresize_limit = 0
  disk_size             = 10
  disk_type             = "PD_HDD"
  user_labels           = { "environment" = "dev" }
  deletion_protection   = "false"
  database_name         = "mysql-dev"
  db_charset            = "utf8mb4"
  db_collation          = "utf8mb4_general_ci"

  zone_availability_type = "ZONAL" # ZONAL NOT HA , REGIONAL IT'S HA
  ipv4_enabled           = "false"
  allocated_ip_range     = "subnet-google-managed-services"

  backup_configuration = {
    binary_log_enabled             = true
    enabled                        = true
    start_time                     = "18:00"
    location                       = "asia-southeast2"
    transaction_log_retention_days = 1
    retained_backups               = 3
    retention_unit                 = "COUNT"
  }

  maintenance_window_day          = 7 # SUNDAY
  maintenance_window_hour         = 18 # the time is UTC TIME which means 1 AM in WIB FORMAT
  maintenance_window_update_track = "stable"
}