data "openstack_identity_auth_scope_v3" "current" {
  name = "current_scope"
}

data "openstack_networking_network_v2" "network" {
  name = var.network_name
}

data "openstack_images_image_v2" "image" {
  name = var.image_name
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

data "openstack_compute_instance_v2" "server" {
  id = var.server_id
}
