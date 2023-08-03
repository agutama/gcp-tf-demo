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
    module_name = "blueprints/terraform/terraform-google-sql-db:postgresql/v12.0.0"
  }
  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-sql-db:postgresql/v12.0.0"
  }
  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/cloudsql/dev/postgresql/"
  }
}


module "default" {
  source                = "../../../modules/cloudsql-with-secret-manager/"
  instance_name         = "dev-cloudsql-psql"
  instance_type         = "db-custom-2-4096"
  region                = "asia-southeast2"
  zone                  = "asia-southeast2-a"
  vpc_network           = "vpc-dev"
  database_version      = "POSTGRES_10"
  project               = "cukzlearn03"
  disk_autoresize       = true
  disk_autoresize_limit = 0
  disk_size             = 10
  disk_type             = "PD_HDD"
  environment           = { "environment" = "dev" }
  deletion_protection   = "false"
  database_name         = "psql-dev"

  zone_availability_type = "ZONAL" # ZONAL NOT HA , REGIONAL IT'S HA
  ipv4_enabled           = "false"
  allocated_ip_range     = "subnet-google-managed-services"



  maintenance_window_day          = 7 # SUNDAY
  maintenance_window_hour         = 6 # the time it's UTC TIME which means 1 AM in WIB FORMAT
  maintenance_window_update_track = "stable"

}