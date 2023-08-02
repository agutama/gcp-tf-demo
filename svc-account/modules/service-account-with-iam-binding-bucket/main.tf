# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam

variable "service_project" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "roles" {
  type = list(any)
}

variable "bucket_name" {
  type = string
}

resource "google_service_account" "service_account" {
  project    = var.service_project
  account_id = var.service_account_name
}

locals {
  all_service_account_roles = concat(var.roles)
}

resource "google_storage_bucket_iam_member" "member" {
  for_each = toset(local.all_service_account_roles)

  bucket = var.bucket_name
  role   = each.value
  member = "serviceAccount:${google_service_account.service_account.email}"
}