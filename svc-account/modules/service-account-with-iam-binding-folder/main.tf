variable "service_project" {
  type = string
}

variable "folder_and_roles" {
  type = map(list(string))
}

variable "service_account_name" {
  type = string
}

resource "google_service_account" "service_account" {
  project    = var.service_project
  account_id = var.service_account_name
}

locals {
  folder_and_roles_flatten = flatten([
    for folder, roles in var.folder_and_roles : [
      for role in roles : {
        folder = folder
        role   = role
      }
    ]
  ])
}

resource "google_folder_iam_member" "service_account-roles" {
  for_each = {
    for permission in local.folder_and_roles_flatten : "${permission.folder}.${permission.role}}" => permission
  }

  folder = "folders/${each.value.folder}"
  role   = each.value.role
  member = "serviceAccount:${google_service_account.service_account.email}"
}
