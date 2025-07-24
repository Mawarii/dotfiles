# cloud net
resource "hcloud_network" "k8s" {
  name     = "k8s_net"
  ip_range = "172.16.0.0/12"
}

# cloud subnet
resource "hcloud_network_subnet" "k8s" {
  network_id   = hcloud_network.k8s.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "172.16.1.0/24"
}

# cp network attachement
resource "hcloud_server_network" "cp" {
  for_each   = hcloud_server.control-planes
  server_id  = each.value.id
  network_id = hcloud_network.k8s.id
}

# worker network attachement
resource "hcloud_server_network" "worker" {
  for_each   = hcloud_server.worker
  server_id  = each.value.id
  network_id = hcloud_network.k8s.id
}
