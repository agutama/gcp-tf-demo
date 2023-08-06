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
  count_compute        = 6
  count_start          = 1
  instance_name_header = "generic"
  compute_name         = "test"
  compute_type         = "e2-medium"
  compute_zones        = ["asia-southeast2-a", "asia-southeast2-b", "asia-southeast2-c"]
  ip_forward           = false
  subnetwork           = "subnet-dev-sea2-app"
  subnetwork_project   = "${var.project}"
  source_image_project = "${var.project}"
  images_name          = "base-template-centos-7"
  size_root_disk       = 20
  type_root_disk       = "pd-balanced"

  # access_config = [{
  #   network_tier = "PREMIUM"
  # }, ]

  #LABEL
  env           = "dev"
  service_group = "infra"
  service_name  = "tools"
  service_type  = "server"

  #Network Tags
  additional_tags = ["test","ssh"]
}
