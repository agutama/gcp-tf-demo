variable "project" {
  type = string
}

variable "source_image_project" {
  default = ""
}

variable "region" {
  default = ""
}

variable "count_compute" {
  default = ""
}

variable "count_start" {
  default = ""
}

variable "instance_name_header" {
  default = ""
}

variable "compute_name" {
  default = ""
}

variable "compute_type" {
  default = ""
}

variable "compute_zones" {
  default = []
}

variable "deletion_protection" {
  default = false
}

variable "ip_forward" {
  default = ""
}

variable "images_name" {
  default = ""
}

variable "size_root_disk" {
  default = ""
}

variable "type_root_disk" {
  default = ""
}

variable "subnetwork" {
  default = ""
}

variable "subnetwork_project" {
  default = ""
}

variable "static_internal_ip_address" {
  default = null
}

variable "env" {
  default = ""
}

variable "service_group" {
  default = ""
}

variable "service_name" {
  default = ""
}

variable "service_type" {
  default = ""
}

variable "min_cpu_platform" {
  default = ""
}

variable "additional_tags" {
  type    = list(string)
  default = []
}

variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    network_tier = string
  }))
  default = []
}

variable "service_account" {
  type = list(object({
    email = string
  }))
  default = []
}

variable "static_external_ip_address" {
  default = ""
}