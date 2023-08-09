terraform {
  required_version = ">= 1.3"
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
    prefix = "state/wif/dev/github"
  }
}

data "google_service_account" "cicd-dev" {
  account_id = "cicd-dev"
  project    = "cukzlearn03"
}

module "github-wif" {
  source      = "../../modules/github-wif"
  project_id  = "cukzlearn03"
  pool_id     = "github-pool"
  provider_id = "github-provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  issuer_uri = "https://token.actions.githubusercontent.com"

  service_accounts = [
    {
      name           = data.google_service_account.cicd-dev.name
      attribute      = "attribute.repository/agutama"
      all_identities = true
    }
  ]
}