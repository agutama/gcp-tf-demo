terraform {
  required_version = ">= 0.14"
  required_providers {
    google      = "~> 3.10"
    google-beta = "~> 3.10"
  }
  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/service-account/dev/artifact/"
  }
}

provider "google" {}
provider "google-beta" {}

module "service-account" {
  source               = "../../../modules/service-account"
  service_project      = "cukzlearn03"
  service_account_name = "cicd-dev"
  roles                = [
    "roles/artifactregistry.reader",
    "roles/artifactregistry.writer",
    "roles/artifactregistry.repoAdmin",
    "roles/artifactregistry.admin",
  ]
}
