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
    prefix = "state/compute-engine/backend/"
  }
}

resource "google_compute_address" "backend-sea2-internal-ip" {
  count        = 1
  name         = "backend-sea2-internal-ip"
  project      = "cukzlearn03"
  subnetwork   = "projects/cukzlearn03/regions/asia-southeast2/subnetworks/subnet-dev-sea2-app"
  address_type = "INTERNAL"
  region       = "asia-southeast2"
  purpose      = "GCE_ENDPOINT"
}

module "default" {
  source                      = "../../../modules/compute-engine"
  project                     = "cukzlearn03"
  count_compute               = 1
  count_start                 = 1
  instance_name_header        = "dev-sea2"
  compute_name                = "backend"
  compute_type                = "e2-small"
  compute_zones               = ["asia-southeast2-a", "asia-southeast2-b", "asia-southeast2-c"]
  ip_forward                  = false
  subnetwork                  = "subnet-dev-sea2-app"
  subnetwork_project          = "cukzlearn03"
  images_name                 = "base-template-ubuntu-22-04"
  size_root_disk              = 20
  type_root_disk              = "pd-standard"
  static_internal_ip_address  = google_compute_address.backend-sea2-internal-ip[0].self_link

  #LABEL
  env           = "dev"
  service_group = "app"
  service_name  = "docker"
  service_type  = "backend-server"

  #Network Tags
  additional_tags = ["backend-server", "ssh"]
}