provider "google" {
  project = var.project
  region  = var.region
}

data "google_compute_image" "boot_img" {
  name    = var.images_name
  project = var.source_image_project
}

resource "google_compute_instance" "compute-instance" {
  count          = var.count_compute
  name           = format("vm-%s-%s-%d", var.instance_name_header, var.compute_name, count.index + var.count_start)
  machine_type   = var.compute_type
  zone           = element(var.compute_zones, count.index)
  can_ip_forward = var.ip_forward
  deletion_protection = var.deletion_protection

  boot_disk {
    initialize_params {
      image = data.google_compute_image.boot_img.self_link
      size  = var.size_root_disk
      type  = var.type_root_disk
    }
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = var.static_internal_ip_address

    dynamic "access_config" {
      for_each = var.access_config
      content {
          network_tier = access_config.value.network_tier
          nat_ip = var.static_external_ip_address
        }
      }
  }

  labels = {
    environment   = var.env
    service_group = var.service_group
    service_name  = var.service_name
    service_type  = var.service_type
    name          = format("vm-%s-%s", var.instance_name_header, var.compute_name)
    created_by    = "terraform"
  }

  tags = var.additional_tags


  allow_stopping_for_update = true
  min_cpu_platform          = var.min_cpu_platform

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "true"
  }

  dynamic "service_account" { 
    for_each = var.service_account
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    content {
      email  = service_account.value.email
      scopes = ["cloud-platform"]
    }
  }

}