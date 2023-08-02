# Create new storage bucket for tf-state
# with standard storage

resource "random_id" "rand" {
  byte_length = 2
}

resource "google_storage_bucket" "default" {
  name          = "${var.project}-${var.bucket_name}"
  project       = "${var.project}"
  location      = "${var.location}"
  force_destroy = "true"

  uniform_bucket_level_access = true
}