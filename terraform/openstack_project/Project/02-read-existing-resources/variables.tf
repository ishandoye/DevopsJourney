variable "cloud_name" {
  type        = string
  description = "Cloud entry name from clouds.yaml"
}

variable "network_name" {
  type        = string
  description = "Existing network name to read"
}

variable "image_name" {
  type        = string
  description = "Existing image name to read"
}

variable "flavor_name" {
  type        = string
  description = "Existing flavor name to read"
}

variable "server_id" {
  type        = string
  description = "Existing server UUID to read"
}
