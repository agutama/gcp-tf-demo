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
    prefix = "state/compute-engine/dev/generic/"
  }
}

module "compute-engine-test" {
  source               = "../../../modules/compute-engine/"
  project              = "${var.project}"
  count_compute        = 1
  count_start          = 1
  instance_name_header = "generic"
  compute_name         = "${var.compute_name}"
  compute_type         = "e2-small"
  compute_zones        = "${var.location}"
  ip_forward           = false
  subnetwork           = "subnet-dev-sea2-app"
  subnetwork_project   = "${var.project}"
  source_image_project = "${var.project}"
  images_name          = "base-template-ubuntu-22-04"
  size_root_disk       = 20
  type_root_disk       = "pd-balanced"

  access_config = [{
    network_tier = "PREMIUM"
  }, ]

  #LABEL
  env           = "dev"
  service_group = "infra"
  service_name  = "tools"
  service_type  = "gce"

  #Network Tags
  additional_tags = ["test","ssh"]
}
