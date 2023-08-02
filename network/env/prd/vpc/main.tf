terraform {
  required_version = ">= 0.14"
  required_providers {
    google      = "~> 3.90"
    google-beta = "~> 3.90"
  }

  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/network/prd/vpc"
  }
}

module "vpc-prd" {
  source                               = "../../../modules/vpc"
  project                              = "${var.project}"
  name                                 = "${var.vpc_name}-prd"
  global_routing                       = false
  subnets = {
    "subnet-prd-sea2-app" = {
      range          = "10.100.0.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-prd-sea2-db" = {
      range          = "10.100.2.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-prd-sea2-dmz" = {
      range          = "10.100.4.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-prd-sea2-k8s-cluster" = {
      range          = "10.100.40.0/22"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges = {
        pods = "10.100.128.0/18",
        services-1 = "10.100.32.0/23",
        services-2 = "10.100.34.0/23"
      },
    },
    "subnet-tools-prd-sea2-app" = {
      range          = "10.100.6.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-tools-prd-sea2-db" = {
      range          = "10.100.8.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-tools-prd-sea2-dmz" = {
      range          = "10.100.10.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-tools-prd-sea2-k8s-cluster" = {
      range          = "10.100.44.0/22"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges = {
        pods = "10.100.192.0/18",
        services-1 = "10.100.36.0/23",
        services-2 = "10.100.38.0/23"
      },
    },
  }
}