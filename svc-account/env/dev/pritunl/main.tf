terraform {
  required_version = ">= 0.14"
  required_providers {
    google      = "~> 3.10"
    google-beta = "~> 3.10"
  }
  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/service-account/dev/pritunl/"
  }
}

provider "google" {}
provider "google-beta" {}

module "service-account" {
  source               = "../../../modules/service-account"
  service_project      = "cukzlearn03"
  service_account_name = "pritunl-dev"
  roles                = [
    "roles/logging.logWriter",
  ]
}
