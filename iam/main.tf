terraform {
  required_version = ">= 0.14"
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
    prefix = "state/projects/iam/"
  }
}


module "projects-iam" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam/"
  version = "~> 6.4"

  mode     = "additive"
  projects = ["cukzlearn03"]

  bindings = {
    "roles/editor" = [
      "user:aguswibawabudi@gmail.com",
    ]
  }
}