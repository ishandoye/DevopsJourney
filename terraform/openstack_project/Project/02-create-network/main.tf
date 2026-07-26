data "openstack_networking_network_v2" "external" {
  name = var.external_network_name
}

resource "openstack_networking_network_v2" "private" {
  name = var.network_name
}

resource "openstack_networking_subnet_v2" "private" {
  name       = var.subnet_name
  network_id = openstack_networking_network_v2.private.id
  cidr       = var.cidr
  ip_version = 4
}

resource "openstack_networking_router_v2" "router" {
  name                = var.router_name
  external_network_id = data.openstack_networking_network_v2.external.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private.id
}
