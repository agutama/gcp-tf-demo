terraform {
  required_version = ">= 0.14"
  required_providers {
    google      = "~> 3.90"
    google-beta = "~> 3.90"
  }

  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/firewall/dev"
  }
}

data "google_compute_network" "vpc-dev" {
  name    = "vpc-dev"
  project = "cukzlearn03"
}


resource "google_compute_firewall" "vpc-dev-allow-ingress-from-iap" {
  name    = "vpc-dev-allow-ingress-from-iap"
  network = data.google_compute_network.vpc-dev.id
  project = "cukzlearn03"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}

resource "google_compute_firewall" "vpc-dev-allow-ingress-https" {
  name    = "vpc-dev-allow-ingress-https"
  network = data.google_compute_network.vpc-dev.id
  project = "cukzlearn03"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  allow {
    protocol = "udp"
    ports    = ["13131"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
  target_tags = ["pritunl"]
}

resource "google_compute_firewall" "vpc-dev-allow-ingress-pritunl" {
  name    = "vpc-dev-allow-ingress-ssh"
  network = data.google_compute_network.vpc-dev.id
  project = "cukzlearn03"
  description = "Allow SSH Ingress"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
  target_tags = ["ssh"]
}


resource "google_compute_firewall" "vpc-dev-allow-internal-traffic" {
  name    = "vpc-dev-allow-internal-traffic"
  network = data.google_compute_network.vpc-dev.id
  project = "cukzlearn03"
  description = "Allow Traffic for Internal VPC Network"

  allow {
    protocol = "all"
  }

  source_ranges = [
    "10.0.0.0/8",
  ]
}