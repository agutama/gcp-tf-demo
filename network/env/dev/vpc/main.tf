terraform {
  required_version = ">= 0.14"
  required_providers {
    google      = "~> 3.90"
    google-beta = "~> 3.90"
  }



  backend "gcs" {
    bucket = "cukzlearn03-terraform"
    prefix = "state/network/dev/vpc"
  }
}

module "vpc-dev" {
  source                               = "../../../modules/vpc"
  project                              = "${var.project}"
  name                                 = "${var.vpc_name}-dev"
  global_routing                       = false
  subnets = {
    "subnet-dev-sea2-app" = {
      range          = "10.20.0.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-dev-sea2-db" = {
      range          = "10.20.2.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-dev-sea2-dmz" = {
      range          = "10.20.4.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-dev-sea2-k8s-cluster" = {
      range          = "10.20.40.0/22"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges = {
        pods = "10.20.128.0/18",
        services-1 = "10.20.32.0/23",
        services-2 = "10.20.34.0/23"
      },
    },
    "subnet-tools-dev-sea2-app" = {
      range          = "10.20.6.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-tools-dev-sea2-db" = {
      range          = "10.20.8.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-tools-dev-sea2-dmz" = {
      range          = "10.20.10.0/23"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges         = null
    },
    "subnet-tools-dev-sea2-k8s-cluster" = {
      range          = "10.20.44.0/22"
      private_access = true,
      region         = "${var.location}",
      log            = false,
      ranges = {
        pods = "10.20.192.0/18",
        services-1 = "10.20.36.0/23",
        services-2 = "10.20.38.0/23"
      },
    },
  }
}