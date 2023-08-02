terraform {
  required_version = ">= 0.14"
  required_providers {
    google      = "~> 3.90"
    google-beta = "~> 3.90"
  }

  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/network/prd/cloud-nat"
  }
}


resource "google_compute_router" "router" {
  project = "${var.project}"
  name    = "router-prd"
  network = "${var.vpc_name}-prd"
  region  = "${var.location}"
}

module "cloud-nat" {
  source     = "../../../modules/cloud-nat/"
  router     = "${google_compute_router.router.name}"
  project_id = "${var.project}"
  region     = "${var.location}"
  name       = "cloud-nat-${google_compute_router.router.name}"
}