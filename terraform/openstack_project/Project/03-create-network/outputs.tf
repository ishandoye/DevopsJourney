output "external_network_id" {
  value = data.openstack_networking_network_v2.external.id
}

output "private_network_id" {
  value = openstack_networking_network_v2.private.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.private.id
}

output "router_id" {
  value = openstack_networking_router_v2.router.id
}
