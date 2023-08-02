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
    prefix = "state/compute-engine/dev/pritunl/"
  }
}

module "pritunl-dev" {
  source               = "../../../modules/compute-engine/"
  project              = "cukzlearn03"
  count_compute        = 1
  count_start          = 1
  instance_name_header = "dev-se2"
  compute_name         = "pritunl"
  compute_type         = "e2-small"
  compute_zones        = ["asia-southeast2-a", "asia-southeast2-b", "asia-southeast2-c"]
  ip_forward           = false
  subnetwork           = "subnet-tools-dev-sea2-app"
  subnetwork_project   = "cukzlearn03"
  source_image_project = "cukzlearn03"
  images_name          = "base-template-ubuntu-22-04"
  size_root_disk       = 20
  type_root_disk       = "pd-balanced"

  service_account = [{
    email = "pritunl-dev@cukzlearn03.iam.gserviceaccount.com"
  }, ]

  access_config = [{
    network_tier = "PREMIUM"
  }, ]

  #LABEL
  env           = "dev"
  service_group = "infra"
  service_name  = "pritunl-dev"
  service_type  = "vpn"

  #Network Tags
  additional_tags = ["pritunl","ssh"]
}
