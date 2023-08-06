variable "project" {
  type = string
  default = "cukzlearn03"
}
variable "location" {
  type = list
  default = ["asia-southeast2-a", "asia-southeast2-b", "asia-southeast2-c"]
}
variable "compute_name" {
  type = string
  default = "test"
}