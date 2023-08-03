variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "global_routing" {
  type = bool
}

variable "subnets" {
  type = map(object({
    range          = string,
    private_access = bool,
    region         = string,
    log            = bool,
    ranges         = map(string)
  }))
}


resource "google_compute_network" "vpc" {
  name                            = var.name
  project                         = var.project
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each                 = var.subnets
  name                     = each.key
  project                  = var.project
  ip_cidr_range            = each.value.range
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = each.value.private_access
  region                   = each.value.region
  dynamic "log_config" {
    for_each = each.value.log == true ? [1] : []
    content {
      flow_sampling        = 0.1
      aggregation_interval = "INTERVAL_5_SEC"
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
  dynamic "secondary_ip_range" {
    for_each = each.value.ranges == null ? {} : each.value.ranges
    content {
      range_name    = "${each.key}-${secondary_ip_range.key}"
      ip_cidr_range = secondary_ip_range.value
    }
  }
}

resource "google_compute_global_address" "private_ip_address" {
  project       = var.project
  name          = "subnet-google-managed-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
    project = var.project
  peering              = google_service_networking_connection.default.peering
  network              = google_compute_network.vpc.name
  import_custom_routes = true
  export_custom_routes = true
}