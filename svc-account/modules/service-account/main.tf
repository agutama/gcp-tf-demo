variable "service_project" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "roles" {
    type    = list
}

resource "google_service_account" "service_account" {
  project    = var.service_project
  account_id = var.service_account_name
}

locals {
  all_service_account_roles = concat(var.roles)
}

resource "google_project_iam_member" "service_account-roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.service_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

