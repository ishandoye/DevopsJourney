output "auth_scope_project_name" {
  value = data.openstack_identity_auth_scope_v3.current.project_name
}

output "network_id" {
  value = data.openstack_networking_network_v2.network.id
}

output "image_id" {
  value = data.openstack_images_image_v2.image.id
}

output "flavor_id" {
  value = data.openstack_compute_flavor_v2.flavor.id
}

output "server_name" {
  value = data.openstack_compute_instance_v2.server.name
}

output "server_flavor" {
  value = data.openstack_compute_instance_v2.server.flavor_name
}
