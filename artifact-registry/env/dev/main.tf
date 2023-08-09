terraform {
  required_version = ">=0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.10"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.10"
    }
  }
  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/artifact/dev/"
  }
}

module "default" {
    source                      = "../../modules/artifact"
    project                     = "cukzlearn03"
    repository_id               = "laravel8"
    location                    = "asia-southeast2"
    format                      = "DOCKER"

}