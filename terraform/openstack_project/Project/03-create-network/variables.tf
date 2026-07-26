variable "cloud_name" {
  description = "Cloud entry name from clouds.yaml"
  type        = string
}

variable "external_network_name" {
  description = "Name of the external/public network"
  type        = string
}

variable "network_name" {
  description = "Name of the private network to create"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet to create"
  type        = string
}

variable "cidr" {
  description = "CIDR for the private subnet"
  type        = string
}

variable "router_name" {
  description = "Name of the router to create"
  type        = string
}
