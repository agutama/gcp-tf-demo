variable "service_project" {
  type = string
}

variable "project_and_roles" {
  type = map(list(string))
}

variable "service_account_name" {
  type = string
}

variable "cluster_identity_namespace" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "k8s_service_account" {
  type = string
}

resource "google_service_account" "service_account" {
  project    = var.service_project
  account_id = var.service_account_name
}

locals {
  project_and_roles_flatten = flatten([
    for project, roles in var.project_and_roles: [
      for role in roles: {
        project = project
        role = role
      }
    ]
  ])
}

resource "google_project_iam_member" "service_account-roles" {
  for_each = {
    for permission in local.project_and_roles_flatten : "${permission.project}.${permission.role}}" => permission
  }

  project = each.value.project
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account_iam_binding" "service_account_iam_binding" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.cluster_identity_namespace}[${var.k8s_namespace}/${var.k8s_service_account}]"
  ]
}
